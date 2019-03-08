# frozen_string_literal: true

describe LocalAuthority::UseCase::PopulateReturnTemplate do
  let(:template_schema) { { properties: {} } }
  let(:matching_baseline_data) { '' }
  let(:copy_paths) { { paths: [{ from: [], to: [] }] } }

  let(:found_template) do
    Common::Domain::Template.new.tap do |t|
      t.schema = template_schema
    end
  end
  let(:template_gateway) { spy(find_by: found_template) }
  let(:find_path_data) { spy(execute: { found: matching_baseline_data }) }
  let(:get_schema_copy_paths) { spy(execute: copy_paths) }
  let(:path_types) { [] }
  let(:get_return_template_path_types) { spy(execute: { path_types: path_types }) }
  let(:use_case) do
    described_class.new(
      find_path_data: find_path_data,
      get_schema_copy_paths: get_schema_copy_paths,
      get_return_template_path_types: get_return_template_path_types
    )
  end

  context 'finds the path' do
    context 'example 1' do
      let(:template_schema) { { properties: {} } }
      let(:baseline_data) do
        {
          names: [
            { pet: 'Edgar' },
            { pet: 'Barker barkington' }
          ]
        }
      end

      it 'finds the correct path' do
        use_case.execute(schema: {fields: 'cat'}, data: {baseline_data: baseline_data})
        expect(get_schema_copy_paths).to have_received(:execute).with(schema: {fields: 'cat'})
      end

      it 'calls with the correct GetReturnTemplatePathTypes' do
        use_case.execute(schema: { fields: 'cat' }, data: {baseline_data: baseline_data})
        expect(get_return_template_path_types).to have_received(:execute).with(schema: {fields: 'cat'}, path: [])
      end
    end

    context 'example 2' do
      let(:template_schema) { { properties: {} } }
      let(:copy_paths) { { paths: [{ to: [:cat], from: [] }] } }
      let(:baseline_data) do 
        {
          names: [
            { pet: 'Mrs Bark' },
            { pet: 'Meow Meow Fuzzyface' }
          ]
        }
      end

      it 'finds the correct path' do
        use_case.execute(schema: { type: 'dog'}, data: {baseline_data: baseline_data})
        expect(get_schema_copy_paths).to have_received(:execute).with(schema: {type: 'dog'})
      end

      it 'calls with the correct GetReturnTemplatePathTypes' do
        use_case.execute(schema: { fields: 'cat' }, data: {baseline_data: baseline_data})
        expect(get_return_template_path_types).to have_received(:execute).with(schema: {fields: 'cat'}, path: [:cat])
      end
    end
  end

  context 'Given a single toplevel baseline key in the schema' do
    let(:path_types) { %i[object object] }
    let(:baseline_data) do
      {
        cats: 'Meow'
      }
    end

    let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          noise:
          {
            sourceKey: %i[baseline_data cats]
          }
        }
      }
    end

    let(:matching_baseline_data) { 'Meow' }
    let(:copy_paths) { { paths: [{ from: [:cats], to: [:noise] }] } }

    it 'populates a simple template' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data })
      expect(result).to eq(populated_data: { noise: 'Meow' })
    end
  end

  context 'Given a single multilevel baseline key in the schema' do
    let(:path_types) { %i[object object] }

    let(:baseline_data) do
      {
        cats: {
          sound: 'Meow'
        }
      }
    end

    let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          noise:
          {
            sourceKey: %i[baseline_data cats sound]
          }
        }
      }
    end

    let(:matching_baseline_data) { 'Meow' }
    let(:copy_paths) { { paths: [{ from: %i[cats sound], to: [:noise] }] } }

    it 'populates a simple template' do
      result = use_case.execute(schema: {type: 'hif'}, data: { baseline_data: baseline_data })
      expect(result).to eq(populated_data: { noise: 'Meow' })
    end
  end

  context 'given a return with multiple properties on one level in an array' do
    let(:path_types) { %i[object array object] }
    let(:baseline_data) do
      {
        cats: {
          sound: 'Meow',
          breed: 'Tabby'
        }
      }
    end

    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          cat:
          {
            type: 'array',
            items:
            {
              type: 'object',
              properties:
              {
                noise:
                {
                  sourceKey: %i[baseline_data cats sound]
                },
                breed:
                {
                  sourceKey: %i[baseline_data cats breed]
                }
              }
            }
          }
        }

      }
    end

    let(:find_path_data) do
      Class.new do
        def execute(data:, path: )
          if path == %i[cats sound]
            { found: ['Meow'] }
          elsif path == %i[cats breed]
            { found: ['Tabby'] }
          end
        end
      end.new
    end

    let(:copy_paths) do
      { paths: [{ from: %i[cats sound], to: %i[cat noise] },
                { from: %i[cats breed], to: %i[cat breed] }] }
    end

    it 'populates a simple template' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data })
      expect(result).to eq(populated_data: { cat: [{ noise: 'Meow', breed: 'Tabby' }] })
    end
  end

  context 'Given a single multilevel return with a baselineKey' do
    let(:path_types) { %i[object object object] }
    let(:baseline_data) do
      {
        cats: {
          sound: 'Meow'
        }
      }
    end

    let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          noise:
          {
            type: 'object',
            properties:
            {
              cat: {
                sourceKey: %i[baseline_data cats sound]
              }
            }
          }
        }
      }
    end

    let(:matching_baseline_data) { 'Meow' }
    let(:copy_paths) { { paths: [{ from: %i[cats sound], to: %i[noise cat] }] } }

    it 'populates a simple template' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data })
      expect(result).to eq(populated_data: { noise: { cat: 'Meow' } })
    end
  end

  context 'Multiple single level keys in the schema' do
    let(:path_types) { %i[object object] }
    let(:baseline_data) do
      {
        cats:
        {
          sound: 'Meow'
        },
        dogs:
        {
          sound: 'Woof'
        }
      }
    end

    let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          cat:
          {
            sourceKey: %i[baseline_data cats sound]
          },
          dog:
          {
            sourceKey: %i[baseline_data dogs sound]
          }
        }
      }
    end
    let(:copy_paths) do
      { paths: [
        { from: %i[cats sound], to: [:cat] },
        { from: %i[dogs sound], to: [:dog] }
      ] }
    end

    let(:find_path_data) do
      Class.new do
        def execute(data:, path:)
          if path == %i[cats sound]
            { found: 'Meow' }
          elsif path == %i[dogs sound]
            { found: 'Woof' }
          end
        end
      end.new
    end

    it 'populates a template' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data })
      expect(result).to eq(populated_data: { cat: 'Meow', dog: 'Woof' })
    end
  end

  context 'with an array' do
    let(:path_types) { %i[object array object] }
    let(:baseline_data) do
      {
        cats: [
          { sound: 'Meow' },
          { sound: 'Nyan' }
        ]
      }
    end

    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          kittens:
          {
            type: 'array',
            items:
            {
              type: 'object',
              properties:
              {
                noise: {
                  sourceKey: %i[baseline_data cats sound]
                }
              }
            }
          }
        }
      }
    end
    let(:copy_paths) do
      { paths: [
        { from: %i[cats sound], to: %i[kittens noise] }
      ] }
    end

    let(:matching_baseline_data) { %w[Meow Nyan] }

    it 'populates a single level template' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data })
      expect(result).to eq(populated_data: { kittens: [{ noise: 'Meow' }, { noise: 'Nyan' }] })
    end
  end

  context 'with a list in an array' do
    let(:path_types) { %i[object array array object] }
    let(:baseline_data) do
      {
        cats: [
          { sound: 'Meow' },
          { sound: 'Nyan' }
        ]
      }
    end

    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          kittens:
          {
            type: 'array',
            items:
            {
              type: 'object',
              properties:
              {
                noises:
                {
                  type: 'array',
                  items:
                  {
                    type: 'object',
                    properties:
                    {
                      sounds:
                      {
                        sourceKey: %i[baseline_data cats sounds]
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    end
    let(:copy_paths) do
      { paths: [
        { from: %i[cats sounds], to: %i[kittens noises sounds] }
      ] }
    end

    let(:matching_baseline_data) { [%w[Meow Nyan], %w[Eow Nya]] }

    it 'populates a single level template' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data })
      expect(result).to eq(populated_data: {
                             kittens:
                             [
                               {
                                 noises:
                                 [
                                   { sounds: 'Meow' },
                                   { sounds: 'Nyan' }
                                 ]
                               },
                               {
                                 noises:
                                 [
                                   { sounds: 'Eow' },
                                   { sounds: 'Nya' }
                                 ]
                               }
                             ]
                           })
    end
  end

  context 'Creating a return from another return' do
    let(:path_types) { %i[object object] }
    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          noise:
          {
            sourceKey: %i[return_data cat]
          }
        }
      }
    end

    let(:baseline_data) { {} }
    let(:return_data) do
      {
        cat: 'Meow'
      }
    end

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[return_data cat], to: [:noise] }
        ]
      }
    end

    let(:matching_baseline_data) { 'Meow' }

    it 'is a simple return' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { noise: 'Meow' })
    end
  end

  context 'creating a return to a non-existent simple two level path' do
    let(:path_types) { %i[object unsupported_type] }
    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          cat:
          {
            sourceKey: %i[return_data cats name]
          }
        }
      }
    end

    let(:baseline_data) { {} }
    let(:return_data) { { cats: [] } }

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[return_data cats name], to: %i[cat something] }
        ]
      }
    end

    it 'gives an empty populated_data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: {})
    end
  end

  context 'creating a return with a non-existent source path that contains an array' do
    let(:path_types) { %i[object array object] }
    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          cats:
          {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                cat: {
                  sourceKey: %i[baseline_data cats name]
                }
              }
            }
          }
        }
      }
    end

    let(:matching_baseline_data) { 'Meow' }
    let(:baseline_data) { { cats: [{ name: 'Meow' }] } }
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[return_data cats name], to: %i[cats cat] }
        ]
      }
    end

    it 'gives an empty populated_data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { cats: [] })
    end
  end

  context 'creating a return with a path in a dependency' do
    let(:path_types) { %i[object object] }

    let(:template_schema) do
      {
        type: 'object',
        dependencies:
        {
          cats:
          {
            oneOf: [
              {
                type: 'object',
                properties: {
                  cat: {
                    sourceKey: %i[baseline_data cats name]
                  }
                }
              }
            ]
          }
        }
      }
    end

    let(:baseline_data) { { cats: { name: 'tom' } } }
    let(:matching_baseline_data) { 'tom' }
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[return_data cats name], to: [:cat] }
        ]
      }
    end

    it 'gives an empty populated_data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { cat: 'tom' })
    end
  end

  context 'creating a return with a path in a dependency in an array' do
    let(:path_types) { %i[object array object] }
    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'array',
            items: {
              type: 'object',
              properties: {

              },
              dependencies:
              {
                cats:
                {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        name: {
                          sourceKey: %i[baseline_data cats name]
                        }
                      }
                    }
                  ]
                }
              }
            }
          }
        }
      }
    end

    let(:baseline_data) { { cats: { name: 'tom' } } }
    let(:matching_baseline_data) { ['tom'] }
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[baseline_data cats name], to: %i[top name] }
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { top: [{ name: 'tom' }] })
    end
  end

  context 'given a schema with multiple states' do
    let(:path_types) { %i[object object object] }
    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'object',
            properties: {

            },
            dependencies:
            {
              dogs:
              {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      name: {
                        sourceKey: %i[baseline_data dogs name]
                      }
                    }
                  },
                  {
                    type: 'object',
                    properties: {
                      breed: {
                        type: 'string'
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      }
    end

    let(:baseline_data) { { dogs: { name: 'tom' } } }
    let(:matching_baseline_data) { 'tom' }
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[baseline_data dogs name], to: %i[top name] }
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { top: { name: 'tom' } })
    end
  end

  context 'given a schema with multiple dependencies' do
    let(:path_types) { %i[object object object] }
    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'object',
            properties: {

            },
            dependencies:
            {
              dogs:
              {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      name: {
                        sourceKey: %i[baseline_data cats name]
                      }
                    }
                  }
                ]
              },
              cats:
              {
                oneOf: [
                  {
                    type: 'object'
                  }
                ]
              }
            }
          }
        }
      }
    end

    let(:baseline_data) { { cats: { name: 'tom' } } }
    let(:matching_baseline_data) { 'tom' }
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[baseline_data dogs name], to: %i[top name] }
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { top: { name: 'tom' } })
    end
  end

  context 'given a schema with multiple dependencies and paths' do
    let(:path_types) { %i[object object object] }

    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'object',
            properties: {

            },
            dependencies:
            {
              dogs:
              {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      name: {
                        sourceKey: %i[baseline_data cats name]
                      }
                    }
                  },
                  {
                    type: 'object',
                    properties: {
                      breed: {
                        sourceKey: %i[baseline_data cats breed]
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      }
    end

    let(:baseline_data) do
      {
        cats: {
          name: 'Meow',
          breed: 'Tabby'
        }
      }
    end
    let(:return_data) { {} }

    let(:find_path_data) do
      Class.new do
        def execute(data:, path:)
          if path == %i[baseline_data cats name]
            { found: 'Meow' }
          elsif path == %i[baseline_data cats breed]
            { found: 'Tabby' }
          end
        end
      end.new
    end

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[baseline_data cats name], to: %i[top name] },
          { from: %i[baseline_data cats breed], to: %i[top breed] }
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { top: { name: 'Meow', breed: 'Tabby' } })
    end
  end

  context 'given a schema with multiple dependencies and paths' do
    let(:path_types) { %i[object object object] }

    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'object',
            properties: {

            },
            dependencies:
            {
              dogs:
              {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      name: {
                        sourceKey: %i[baseline_data dogs name]
                      }
                    }
                  }
                ]
              },
              cats:
              {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      breed: {
                        sourceKey: %i[baseline_data cats breed]
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      }
    end

    let(:baseline_data) do
      {
        dogs: {
          name: 'Meow'
        },
        cats: {
          breed: 'Tabby'
        }
      }
    end
    let(:return_data) { {} }

    let(:find_path_data) do
      Class.new do
        def execute(data:, path:)
          if path == %i[baseline_data dogs name]
            { found: 'Meow' }
          elsif path == %i[baseline_data cats breed]
            { found: 'Tabby' }
          end
        end
      end.new
    end

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[baseline_data dogs name], to: %i[top name] },
          { from: %i[baseline_data cats breed], to: %i[top breed] }
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { top: { name: 'Meow', breed: 'Tabby' } })
    end
  end

  context 'creating a return with a path with multiple dependencies in an array' do
    let(:path_types) { %i[object array object] }
    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'array',
            items: {
              type: 'object',
              properties: {

              },
              dependencies:
              {
                cats:
                {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        name: {
                          sourceKey: %i[baseline_data cats name]
                        }
                      }
                    }
                  ]
                },
                dogs:
                {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        breed: {
                          sourceKey: %i[baseline_data cats breed]
                        }
                      }
                    }
                  ]
                }
              }
            }
          }
        }
      }
    end

    let(:baseline_data) { { cats: { name: 'tom' } } }
    let(:find_path_data) do
      Class.new do
        def execute(data:, path:)
          if path == %i[baseline_data cats name]
            { found: ['Timmy'] }
          elsif path == %i[baseline_data cats breed]
            { found: ['Tom'] }
          end
        end
      end.new
    end
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          { from: %i[baseline_data cats name], to: %i[top name] },
          { from: %i[baseline_data cats breed], to: %i[top breed] }
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(schema: { type: 'hif' }, data: { baseline_data: baseline_data, return_data: return_data })
      expect(result).to eq(populated_data: { top: [{ name: 'Timmy', breed: 'Tom' }] })
    end
  end
end
