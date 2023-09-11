# Platform / Backend Engineer Challenge

Our goal with this challenge is to get a sense of how you reason through problems and build software to solve them.

More specifically, we're looking to get a sense of three things:
1. How do you think through the technical aspects of problems? Do your solutions meet the stated parameters? Are they efficient, maintainable, and well-organized?
1. How can you engage non-technical stakeholders to understand the problem space and explain how the solution impacts them?
1. Our core values include Collaboration, Kindness, and Improvement.
    - How well do you work within a team to collaborate and iterate on solutions?
    - How do you leverage your strengths to help your teammates improve?

### Deliverables will take two forms:
**The code you've written to meet the parameters of the challenge.**
- It doesn't have to be bulletproof but should include tests and documentation as you feel may be appropriate.

**A synchronous video discussion to review the challenge and talk through your approach and the considerations behind it.**
- We want to understand why you made the decisions you did and throw a few curveballs based on real-world feedback to see how you can collaboratively work through the feedback and iterate on your approaches.
- We will likely include some pairing on extensions to the challenge as well. Extensions will look different depending on your experience level and code submission. We'll let you know before the discussion if there's anything else to prepare.

Your code deliverable can either be an archive (tar or zip) - e.g., a downloaded snapshot from a Github repository - or just shared access to the repo itself.

We expect that you may have questions - the challenge is built inside Highwing's problem domain, which can sometimes be obtuse.  Please feel free to ask clarifying questions as you see fit. We'd much rather you ask for clarification than churn in isolation. For any questions specific to the challenge, you may reach the team by emailing code-challenge@highwing.io.

We don't want you to spend more than about 5 hours working on this challenge. If you don't finish everything, that's okay. Uncompleted questions are a good jumping-off point for the in-person discussion.


## The Problem

Highwing is in the process of onboarding a new insurance broker and looking to ingest their list of active insurance policies in order to make it available to insurance carriers to identify policies that they (the carrier) may be interested in competing to write. These policies are all property and casualty insurance - i.e., no health, benefits, or life. It comes from the broker's internal management systems, which have few (if any) validation capabilities built-in.

The ultimate goal is to expose this client's book to Highwing's carrier partners so that carrier users can spot opportunities that may be of interest to them and choose to pursue them. Chasing down an opportunity costs a fair bit of time, so we want to make sure that the data we provide to the carriers is good enough to be worth the effort they are investing to pursue. Carriers are specifically interested in policies that are renewing in the coming months - i.e., those that expire in the next 12 months. To that end, we want to evaluate this data with an eye towards two end goals - what work do we need to do with the broker to make this data ready for use, and how do we operationalize it on an ongoing basis?

## Choose Your Own Adventure

You may start with our existing Ruby codebase or start from scratch using whichever language(s) and framework(s) you prefer. Starting from scratch will require you to make some tradeoffs. Lean into the parts that showcase your talents or the parts you are most curious about. The existing Ruby codebase provides a head start by importing the data and exposing a few API endpoints. Read through all sections below before deciding on your strategy. We'd like to see some progress made into Part 3 below. Don't worry if you aren't able to finish since your stopping point is a perfect place to start our discussion.

### Adventure 1: Start with Existing Codebase (Most common)

---

#### 1. Existing Codebase Overview

This project is divided into two parts
1. `data_ingest`: the code responsible for importing data from arbitrary CSV files into a relational database
2. `data_api`: a minimal JSON api capable of querying and returning data from the database.

The `data/` directory contains the original data files provided for the exercise. Each sub-project has a separate README file to provide additional data on how to run the projects.

###### Overall Perspective

We built the Highwing Starter Repo with a focus on flexibility and performance of the data ingest. Given the nature of the challenge, the inconsistency of the data, and the business domain, we made the code capable of changing to meet new data structures or changes in the business requirements. We built a simple, expressive DSL capable of shaping the data into a consistent format along with validations to ensure that the incoming data met a standard prior to being imported into the database. Assuming a few unknowns, our goal was to make it as simple as possible to either reject invalid data or to morph the data to meet a specific format.

We wrote a very simple API to return the data as a JSON data structure.

Finally, we chose a few tools that that are simple and relatively dependency-light (ROM, the Dry libraries), which makes the database layer a bit more open-ended than the conventions Rails would otherwise provide. ROM provides more tooling for a cleaner configuration setup, but we did not make full use of that functionality.

#### 2. [Skip to Part 3](#part-3-upload-encrypted-client-csv-via-api)

### Adventure 2: Build Using Whichever Tools You Prefer

---

#### Part 1: Data Engineering
**(Skip if using the starter codebase)**

The data set consists of three tables - Clients, Carriers, and Policies. You can download them in CSV format [here](/data).

We're looking to load the data into a database to assess it and build some APIs around it. You may use whatever frameworks and helper libraries (e.g., Ruby, Rails, ActiveRecord, Sequel, Rake, Python, Pandas, raw SQL, Sidekiq/Active Job, etc.) you feel are a good fit.
Not a necessary implementation requirement, but be prepared to discuss the process of operationalizing your solution. How would you go about loading data into different environments given your solution? How would your solution adapt to a changing data model in the target database as API features expand? How would you manage updates to existing records, how would you scale for processing records to keep resources available to serve API requests? How would you manage or consider fault tolerance, retries, failed upserts, manual intervention, observation, and monitoring of the data pipeline? How would you ensure order of delivery if needed?

**Required:**

- Build an appropriate data model and script(s) to load data from the **Client CSV** file above into a relational database.
- A working solution need not have any UI but should have an executable task that can be run to load data and queried in a database console.

**For fun or if you'd like to showcase your data engineering chops:**

- Build an appropriate data model and set of scripts to load the remaining CSV files above into a relational database.

#### Part 2: API Design
**(Skip if using the starter codebase)**

Based on the data loaded in part 1, we'd like to start to implement API methods to begin accessing the data.

Build an API that returns some basic information from the data set.
We are not specifying an API protocol (HTTP, Grpc, etc.) or architectural style (REST/GraphQL/etc.), but assume your primary consumer of the API will be a frontend web application, and that the secondary consumer group might be B2B services.

**Required:**

- Return a list of all clients. We'll be checking this endpoint to validate the requirements outlined in Part 3.

You're welcome to use whatever frameworks and helper libraries you see fit to implement your API. There is no need for authentication or access control just yet.

#### Part 3: Upload Encrypted Client CSV Via API
**(Start here if using the starter codebase)**

**High Level Goal:** Our brokers send us data updates and we need to make sure our stored data accurately reflects these updates. For this exercise, you'll build an API endpoint that receives an encrypted file containing updated client records. After the endpoint receives the encrypted file, you'll need to decrypt it and update the clients table. Making a user wait for the file to process could be a frustrating experience. To improve this experience, let's trigger a background job from this new API endpoint and respond with a 200 status and a message stating that the file is being processed.. If using Ruby, something like Sidekiq could be a good option but you're welcome to reach for anything you'd like. Feel free to refactor code in the starter repo!

**Encryption/Decryption**
- We used GPG for encryption. You'll need to have the GPG command line tools installed.
Example: If using homebrew it should look something like:
```
$ brew install gnupg
```
- Or you can download a GnuPG package [here](https://gnupg.org/download/).
File dependencies (private.key, public.key, ClientUpdates.csv.gpg) are available in the [data/part_3_encryption](/data/part_3_encryption) directory
  - Note: We're storing these keys in fairly public spaces to make it easy for the code challenge. We don't condone this behavior ;)

- You should be able to import the private and public keys using something like:
```
$ gpg --import public.key
$ gpg --import private.key
```
- Once you have the keys imported you should be able to decrypt:

```
$ gpg --decrypt --output ClientUpdates.csv ClientUpdates.csv.gpg
```

- **Important:** We want to send the encrypted file to the API endpoint. The decryption process demonstrated above needs to be automated.

**Record Processing Requirements**

- Records that appear in the new spreadsheet and already exist in the table should be updated.
- Records that appear in the new spreadsheet but not in the table should be added.
- Records that appear in the table but not the spreadsheet should be left alone.
- IDs for records that exist in the table should not change when the new CSV is loaded.
- Clients require a name to be valid. We shouldn't store records that aren't valid but it would be good to know which records are invalid so we can fix them.

