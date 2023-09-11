# README

## Notes

This project simply re-uses the existing IDs from the respective ID columns in the files rather than to create a new index and sub-index on the given IDs. 
In the real-world, we might rather create new ID keys and translate the given IDs to a separate column or re-map all associations to reference the new key. 
This would need to be done during the import of subsequent data from other clients/carriers.

We provided a very basic (and very meta) mapping DSL to smooth over the naming differences between the files. 
This DSL (while needing significant improvement) would allow the mapping of multiple input file formats to a standard schema. 
The project generically names the the existing schema `Carrier`, `Client`, and `Policy`, but likely these would end up being client/carrier-specific schema.
While the DSL is "nice", it could be better to make schema mappings configurable outside of code so that onboarding additional clients does not require code change.

The custom typecasting as part of the DSL is extremely fragile and falls far short of libraries like `Dry::Types`, 
but the goal of this project is simplicity over robustness.

The load process can be a bit slow, especially given the size of the Policy data. Ideally, this could be parallelized.

## Running

```bash
bundle
rake db:migrate

# Run tests
rake test

# Run ingest script
./bin/runner.rb
```

If you have an existing DB and want to re-run the import, run `rake db:reset` to wipe the existing data prior to re-importing.
In the real world, the importer would probably do some existing record checks prior to import to avoid collisions.

## Possible Uses

In order to run the code, we provide a simple executable interface in the form of a script. 
Such a script could be used along side a cron job to pickup files in, say, an SFTP server or incorporated into a file watcher to pick up new files.

One could also write an API that utilizes the code sans-runner script and allows files to be sent over the wire.
