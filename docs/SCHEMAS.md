# Monitor Schema
Monitor Schemas are based on the format supported by [React JSON Schema Form](https://react-jsonschema-form.readthedocs.io/en/latest/#json-schema-supporting-status) with a number of extensions and conventions.

## Core vs UI schema and converters
For each distinct form workflow both a core and a UI schema exist. The core schema represents how the data is stored internally, while the UI schema is what is presented to the frontend for rendering. Each version of the schema has a corresponding converter in order to convert it to the other version, these are named by the schema that is being converted from.

Code not under the UI actor will implicitly pertain to core versions of the data. Code under the UI actor will include the converters and use cases that make use of these converters as middle-men before interacting with core use cases.

When moving, adding or deleting items from the UI schema the converters and their tests must be updated to reflect the new layout of the data.

### UI schema
#### `"sharedData":`
Describes data that will be copied between tabs, they follow the structure:
```
"sharedData": [
    {
      "from": [
        "path",
        "to",
        "data",
        "source"
      ],
      "to": [
        "path",
        "to",
        "data",
        "destination"
      ]
    }
  ]
```
Note that the paths do not follow the structure as presented in the schema, but as the schema specifies them.  
Paths that contain numbers indicate that they are getting an item from a particular index in an array. If the number is negative indexing starts from the last item rather than the first.  
Using an index that is out of range is undefined behaviour.

If a `"#"` is used it indicates that every item in an array must be copied, as such there must be a corresponding `"#"` in the path to the destination.
Using a `"#"` in a source or destination without a corresponding `"#"` is undefined behaviour.  

#### Flags
Provides a way to specify the behaviour of a field either for the frontend or the backend, these are in the format:
`"flag": true`  
Excluded flags are implicitly false.

#### Validation
##### Presence validation
Some fields must have data entered in them in order to validate, for this the `"required": true` flag must be set.  

##### Value validation  
Certain fields require specific values, for this we use JSON Schema's `"pattern":`

#### `"calculation":`
Provides a way to perform dynamic calculations and validation in the form. You can find the functions that can be used [here](https://github.com/homes-england/monitor-frontend/blob/master/src/Components/CalculatedField/index.js).

Calculations can only manipulate data that is contained inside them according to the schema. In order to use data from other tabs you should import it using sharedData. Note that certain flags cannot be used with calculations.

### Core schema
#### `"sourceKey":`
This provides a way to pull data from separate forms that are part of the current project. These are typically formatted as arrays made up of a data source followed by the path(s) for pulling from that data source, the following data sources are supported:
  - `baseline_data` - This pulls from the baseline and is followed by the path `[:baseline_data, :my, :path]`
  - `return_data` - This pulls from the return. This is in the format `[:return_data, :my, :path]`
  - `return_or_baseline` - This pulls from the return unless there is no data at that path, in which case it will pull the data from the baseline. `[:return_or_baseline, [:baseline_data, :my, :path], [:return_data, :my, :path]]`

Please note that in this path format arrays do not need to be explicitly indicated, if arrays are encountered it is expected that the destination path is contained with the same depth of arrays.
