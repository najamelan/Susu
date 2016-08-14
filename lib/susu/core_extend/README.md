# @title CoreExtend README

# Susu_Ruby_CoreExtend
 
Extensions to modules and classes from the ruby core library. Currently very basic, only extends Hash with a recursive_merge.

## Usage

```require 'lib/core_extend'```

Now your core functionality shall be extended.

For more fine-grained control, you can require only specific classes:

```require 'lib/core_extend/hash'```

CoreExtend is part of the [Susu Ruby library](https://github.com/najamelan/Susu_Ruby). You can also include Susu Ruby entirely to get CoreExtend with it.

## Unit testing

### Requirements

```apt install ruby-thor```

Also needs 'unit/test'

You can run the unit tests by running (in the main repository directory):

```thor core_extend:test```



