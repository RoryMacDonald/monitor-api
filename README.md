# Monitor API

Monitor is a system that allows Homes England to monitor the status of contracts. This API provides functionality for storing and modifying project and scheme data, which will be served by the [Frontend](https://github.com/homes-england/monitor-frontend).  

The API currently supports the MVF and AC contract schemes.

### Glossary
 - Simulator - A simulator provides functionality that in production would be provided by an external API in a manner conducive to local manual testing. Simulators are not used by the automated test suite.
 - Domain object - A class that describes the interface between gateways and usecases  
 - Gateway - A class that provides abstractions for stores of data (including APIs)
 - Use case - A class that provides discrete functionality for a user story
 - Acceptance tests - Tests that describe a user story
 - Unit tests - Tests that describe micro-features
 - Delivery Mechanism - The method by which data is sent and received from the user
 - Project - A project is made up of a scheme type, baseline and returns
 - Baseline - A form that declares the initial conditions of the project
 - Return - A typically quarterly update to the status of a project
 - AC - [Accelerated Construction](https://www.gov.uk/government/publications/accelerated-construction-local-authorities-expressions-of-interest)
 - MVF - [Marginal Viability Fund](https://www.gov.uk/government/publications/housing-infrastructure-fund)
 - HIF - Housing Infrastructure Fund, now a legacy term referring to MVF. Going forward HIF is a broader term referring to a subset of Homes England schemes.

## Technical documentation

### Directory Structure
 - `docs/` - Further documentation
 - `spec/` - The test suite  
  - `acceptance/` - Tests that describe functionality central to user stories
    - `*/` - Acceptance tests for a given actor
  - `unit/` - Tests that describe micro-features in pursuit of an acceptance test
    - `*/` - Unit tests for a given actor
      - `gateway/` - Tests for gateways
      - `use_case/` - Tests for use cases
  - `web_routes/` - Tests pertaining to the interaction between the outward facing API and the internal implementation
  - `fixtures/` - Moderate to large test data
  - `simulator/` - Tests for simulators
 - `simulators/` - Code pertaining to simulators
 - `lib/` - Code pertaining to core functionality
  - `*/` - Code pertaining to a given actor
    - `domain/` - Domain objects
    - `gateway/` - Gateways
    - `use_case/` - Use cases
 - `db/` - Code pertaining to database migrations

### Dependencies
Working on the Monitor API requires [GNU Make](https://www.gnu.org/software/make/), [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/install/).  
For deploying we make use of [Heroku](https://heroku.com) and [Sentry](https://sentry.io/).

### Running the application

Once you have cloned the repository you can run the application with the following command:

`make serve`

The application runs on port `4567`

### Running the test suite

This project was developed using [ATDD](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development), as such it has an extensive test suite which can be run via:

`make test`

This test suite will run continuously as you save your work.

### Further documentation
[Schemas](docs/SCHEMAS.md)
[Authentication](docs/AUTHENTICATION.md)
