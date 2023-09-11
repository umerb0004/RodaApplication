# Data API

This project provides a minimal API with the following endpoints:
- `summary/`: returns counts for each of the datatypes required by the project
- `clients/`: a paginated listing of all clients in the system. It accepts the following url params:
  - `p=Integer`: the desired page of results; default: 0
  - `count=Integer`: how many results to return in the request; default: 50
- `clients/:id` returns a single client for a given ID
- `clients/:id/policies` returns a client enriched with the policies associated with their account

New endpoint introduced with POST request
- `upload` returns a client enriched with the policies associated with their account

```bash
curl -X POST -H "content-type: multipart/form-data" -F "file=@ClientUpdates.csv.gpg" http://localhost:9292/upload
```
Please make sure to append a right filepath as per your environment.

## Running

:warning: Please ensure the database has been populated and placed in the `../data` directory prior to running. Please note the database name and path in the `api.rb` config.

```bash
bundle
rackup
```

If you have the [Paw API client](https://paw.cloud/), you can use the `API.paw` file for ease of testing locally.