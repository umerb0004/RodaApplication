require 'roda'
require 'rom-sql'
require 'gpgme'

require_relative 'repositories/clients'
require_relative 'repositories/carriers'
require_relative 'repositories/policies'
require_relative 'rom_container'
require_relative 'client_updates_worker'

class API < Roda
  include RomContainer

  plugin :json
  plugin :typecast_params

  container = RomContainer::CONTAINER

  MAX_RANGE = 1000

  def limit_range(count)
    (count > MAX_RANGE) ? MAX_RANGE : count
  end

  def decrypt_file(encrypted_data)
    (GPGME::Crypto.new.decrypt encrypted_data.open.read).read # key already imported in GnuPG
  end

  route do |r|
    client_repo = ClientRepository.new(container)
    carrier_repo = CarrierRepository.new(container)
    policy_repo = PolicyRepository.new(container)

    r.on "summary" do
      r.is do
        r.get do
          {
            policies: policy_repo.count,
            carriers: carrier_repo.count,
            clients: client_repo.count
          }
        end
      end
    end

    r.on "upload" do
      r.is do
        r.post do
          encrypted_data = r.params["file"][:tempfile]

          begin
            decrypted_data = decrypt_file(encrypted_data)
            ClientUpdatesWorker.perform_async(decrypted_data)
            message = "File is being processed in the background"
          rescue GPGME::Error => e
            message = "Error decrypting the encrypted data: #{e.message}"
            response.status = 500
          rescue StandardError => e
            message = "An error occurred: #{e.message}"
            response.status = 500
          end
          
          {
            message: message
          }
        end
      end
    end

    r.on "clients" do
      r.on Integer do |id|
        client = client_repo.find(id)

        r.is "policies" do
          enriched_client = client.with_policies.one
          policies = enriched_client.policies.map(&:to_h)

          {
            count: policies.count,
            client: enriched_client.to_h
          }
        end

        r.get do
          client.one!.to_h
        end
      end

      r.is do
        r.get do
          count = limit_range(typecast_params.pos_int('count', 50))
          page = typecast_params.pos_int('p', 0)

          objects = client_repo.get_paged(count: count, page: page).map(&:to_h)

          # Consider returning 206 if not full response
          # or a 416 if the range is outside of the range of records

          {
            count: count,
            page: page,
            clients: objects
          }
        rescue Roda::RodaPlugins::TypecastParams::Error => e
          {
            error: {
              param: e.param_name,
              message: e.reason
            }
          }
        end
      end
    end
  end
end

