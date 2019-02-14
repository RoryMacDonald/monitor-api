# frozen-string-literal: true

require 'rspec'

describe UI::UseCase::ValidateProject do
  let(:project_type) { 'hif' }
  let(:invalid_project_data_pretty_paths) { nil }
  let(:project_schema_gateway_spy) { double(find_by: template) }

  let(:get_project_template_path_titles_spy) do
    Class.new do
      attr_reader :called_with

      def initialize(invalid_project_data_pretty_paths)
        @called_with = []
        @invalid_project_data_pretty_paths = invalid_project_data_pretty_paths
      end

      def execute(argument)
        @called_with << argument
        { path_titles: @invalid_project_data_pretty_paths.shift }
      end
    end.new(invalid_project_data_pretty_paths.dup)
  end

  let(:template) do
    Common::Domain::Template.new.tap do |p|
      p.schema = {}
    end
  end
  let(:use_case) do
    described_class.new(project_schema_gateway: project_schema_gateway_spy, get_project_template_path_titles: get_project_template_path_titles_spy)
  end

  it 'should accept project type and project data' do
    use_case.execute(type: project_type, project_data: {})
  end

  context 'calling project template gateway' do
    context 'Example 1' do
      let(:project_type) { 'koalas' }
      it 'should call return template gateway with type' do
        use_case.execute(type: project_type, project_data: {})
        expect(project_schema_gateway_spy).to have_received(:find_by).with(type: project_type)
      end
    end

    context 'Example 2' do
      let(:project_type) { 'dogs' }
      it 'should call return template gateway with type' do
        use_case.execute(type: project_type, project_data: {})
        expect(project_schema_gateway_spy).to have_received(:find_by).with(type: project_type)
      end
    end
  end

  shared_examples_for 'required field validation' do
    context 'given a valid project' do
      it 'should return a hash with a valid field as true' do
        project_value = use_case.execute(type: project_type, project_data: valid_project_data)
        expect(project_value[:valid]).to eq(true)
      end

      it 'should have no paths' do
        project_value = use_case.execute(type: project_type, project_data: valid_project_data)
        expect(project_value[:invalid_paths]).to eq([])
      end

      it 'should return no pretty paths' do
        project_value = use_case.execute(type: project_type, project_data: valid_project_data)
        expect(project_value[:pretty_invalid_paths]).to eq([])
      end
    end

    context 'given an invalid project' do
      it 'should return a hash with a valid field as false' do
        project_value = use_case.execute(type: project_type, project_data: invalid_project_data)
        expect(project_value[:valid]).to eq(false)
      end

      it 'should return the correct path' do
        project_value = use_case.execute(type: project_type, project_data: invalid_project_data)
        expect(project_value[:invalid_paths]).to match_array(invalid_project_data_paths)
      end

      it 'should return correct pretty paths' do
        project_value = use_case.execute(type: project_type, project_data: invalid_project_data)
        expect(project_value[:pretty_invalid_paths]).to eq(invalid_project_data_pretty_paths)
      end
    end
  end

  context 'required field validation' do
    context 'given a string' do
      context 'Example 1' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['catsComplete'],
              properties: {
                catsComplete: {
                  type: 'string',
                  title: 'cats compete on the beach to complete the complex beat'
                }
              }
            }
          end
        end

        let(:valid_project_data) { { catsComplete: 'The Cat Plan' } }
        let(:invalid_project_data) { {} }
        let(:invalid_project_data_paths) { [[:catsComplete]] }
        let(:invalid_project_data_pretty_paths) { [['Cats Complete']] }
      end

      context 'Example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['squirrelFight'],
              properties: {
                squirrelFight: {
                  type: 'string',
                  title: 'cats compete on the beach to complete the complex beat'
                }
              }
            }
          end
        end

        let(:valid_project_data) { { squirrelFight: 'Reds rule!' } }
        let(:invalid_project_data) { {} }
        let(:invalid_project_data_paths) { [[:squirrelFight]] }
        let(:invalid_project_data_pretty_paths) { [['Squirrel Fight']] }
      end
    end

    context 'given multiple strings' do
      context 'Example 1' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'Project Summary',
              type: 'object',
              required: %w[catsComplete dogsComplete],
              properties: {
                catsComplete: {
                  type: 'string',
                  title: 'cats compete on the beach to complete the complex beat'
                },
                dogsComplete: {
                  type: 'string',
                  title: 'dogs dance on the beach to demolish the dupstep beat'
                },
                unrequiredComplete: {
                  type: 'string',
                  title: 'who cares'
                }
              }
            }
          end
        end

        let(:valid_project_data) { { catsComplete: 'The Cat Plan', dogsComplete: 'The Dog Plan' } }
        let(:invalid_project_data) { {unrequiredComplete: 'Doo wap'} }
        let(:invalid_project_data_paths) { [[:catsComplete], [:dogsComplete]] }
        let(:invalid_project_data_pretty_paths) { [['Cats Complete'], ['Dogs Complete']] }
      end

      context 'Example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'Project Summary',
              type: 'object',
              required: %w[horsesComplete cowsComplete],
              properties: {
                horsesComplete: {
                  type: 'string',
                  title: 'cats compete on the beach to complete the complex beat'
                },
                cowsComplete: {
                  type: 'string',
                  title: 'dogs dance on the beach to demolish the dupstep beat'
                },
                randomComplete: {
                  type: 'string',
                  title: 'who cares'
                }
              }
            }
          end
        end

        let(:valid_project_data) { { horsesComplete: 'The Cat Plan', cowsComplete: 'The Dog Plan' } }
        let(:invalid_project_data) { {randomComplete: 'Shoop da woop'} }
        let(:invalid_project_data_paths) { [[:horsesComplete], [:cowsComplete]] }
        let(:invalid_project_data_pretty_paths) { [['Horses Complete'], ['Cows Complete']] }
      end
    end

    context 'given a nested field' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['catsComplete'],
                  properties: {
                    catsComplete: {
                      type: 'string',
                      title: 'cats compete on the beach to complete the complex beat'
                    }
                  }
                }
              }
            }
          end
        end

        let(:valid_project_data) do
          {
            planning: {
              catsComplete: '99'
            }
          }
        end

        let(:invalid_project_data) { { planning: {} } }
        let(:invalid_project_data_paths) { [%i[planning catsComplete]] }
        let(:invalid_project_data_pretty_paths) { [['Planning', 'Cats Complete']] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                submitting: {
                  type: 'object',
                  title: 'Planning',
                  required: ['rabbitsFight'],
                  properties: {
                    rabbitsFight: {
                      type: 'string',
                      title: 'cats compete on the beach to complete the complex beat'
                    }
                  }
                }
              }
            }
          end
        end

        let(:valid_project_data) do
          {
            submitting: {
              rabbitsFight: 'The Cat Plan'
            }
          }
        end

        let(:invalid_project_data) { { submitting: {} } }
        let(:invalid_project_data_paths) { [%i[submitting rabbitsFight]] }
        let(:invalid_project_data_pretty_paths) { [['Submitting', 'Rabbits Fight']] }
      end
    end

    context 'given a nested field with an array' do
      context 'example 1' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF',
              type: 'object',
              required: ['flowers'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['catsComplete'],
                  properties: {
                    catsComplete: {
                      type: 'string',
                      title: 'cats compete on the beach to complete the complex beat'
                    }
                  }
                },
                flowers: {
                  type: 'array',
                  title: 'Flowers',
                  minItems: 1,
                  items: {
                    type: 'object',
                    title: 'flowers',
                    properties: {
                      amount: {
                        type: 'integer',
                        title: 'The Integer'
                      }
                    }
                  }
                }
              }
            }
          end
        end

        let(:invalid_project_data) { {} }
        let(:valid_project_data) { { flowers: [{ amount: 3 }, { amount: 5 }] } }
        let(:invalid_project_data_paths) { [[:flowers]] }
        let(:invalid_project_data_pretty_paths) { [['Flowers', 'The Integer']] }
      end

      context 'example 2' do
        Common::Domain::Template.new.tap do |p|
          p.schema = {
            title: 'HIF',
            type: 'object',
            required: ['vegetables'],
            properties: {
              planning: {
                type: 'object',
                title: 'Planning',
                required: ['dogsComplete'],
                properties: {
                  dogsComplete: {
                    type: 'string',
                    title: 'who let the dogs out?'
                  }
                }
              },
              vegetables: {
                type: 'array',
                title: 'Veggies',
                minItems: 1,
                items: {
                  name: {
                    type: 'string',
                    title: 'Veggie name'
                  }
                }
              }
            }
          }
        end
      end
      let(:invalid_project_data) { {} }
      let(:valid_project_data) { { vegetables: [{ name: 'Onion' }, { name: 'Aubergine' }] } }
      let(:invalid_project_data_paths) { [[:vegetables]] }
      let(:invalid_project_data_pretty_paths) { [['Veggies', 'Veggie Name']] }
    end

    context 'given an array with a nested invalid field' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['cows'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  properties: {
                    percentComplete: {
                      type: 'integer',
                      title: 'Percent complete'
                    },
                    notComplete: {
                      type: 'string',
                      title: 'Not Complete'
                    }
                  }
                },
                cows: {
                  type: 'array',
                  title: 'Wearing trousers',
                  items: {
                    type: 'object',
                    required: ['name'],
                    properties:
                    {
                      name: {
                        type: 'string',
                        title: 'Cow Name'
                      }
                    }
                  }
                }
              }
            }
          end
        end
        let(:invalid_project_data) { { cows: [{}] } }
        let(:valid_project_data) { { cows: [{ name: 'Madame Moo' }] } }
        let(:invalid_project_data_paths) { [[:cows, 0, :name]] }
        let(:invalid_project_data_pretty_paths) { [['Planning', 'Wearing trousers', 'Cow Name']] }
      end
    end

    context 'given a nested field with multiple entries' do
      context 'example 1' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'New Project',
              type: 'object',
              required: ['dogs'],
              properties: {
                snakes: {
                  type: 'object',
                  title: 'Snakes',
                  required: ['slivery'],
                  properties: {
                    slivery: {
                      type: 'string',
                      title: 'Slivery'
                    },
                    slimy: {
                      type: 'string',
                      title: 'Slimy'
                    }
                  }
                },
                dogs: {
                  type: 'integer',
                  title: 'How many dogs'
                }
              }
            }
          end
        end

        let(:valid_project_data) { { snakes: { slivery: 'yes' }, dogs: 4 } }
        let(:invalid_project_data) { { snakes: { slimy: 'no' } } }
        let(:invalid_project_data_paths) { [[:dogs], %i[snakes slivery]] }
        let(:invalid_project_data_pretty_paths) { [['How many Dogs'], %w[Snakes Slivery]] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'New Project',
              type: 'object',
              required: ['lizards'],
              properties: {
                mice: {
                  type: 'object',
                  title: 'Mice',
                  required: ['squeaky'],
                  properties: {
                    squeaky: {
                      type: 'string',
                      title: 'Squeaky'
                    },
                    cheese: {
                      type: 'string',
                      title: 'Cheese'
                    }
                  }
                },
                lizards: {
                  type: 'integer',
                  title: 'How many lizards?'
                }
              }
            }
          end
        end

        let(:valid_project_data) { { mice: { squeaky: 'Squeak', cheese: 'Yummy' }, lizards: 2 } }
        let(:invalid_project_data) { { mice: { cheese: 'Old' } } }
        let(:invalid_project_data_paths) { [[:lizards], %i[mice squeaky]] }
        let(:invalid_project_data_pretty_paths) { [['How many lizards?'], %w[Mice Squeaky]] }
      end
    end

    context 'given a nested array with invalid entries' do
      context 'Example 1' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'The Animal March',
              type: 'object',
              properties: {
                pairs: {
                  type: 'array',
                  title: 'The Pairs',
                  items: {
                    type: 'object',
                    required: ['owners'],
                    properties: {
                      class: {
                        type: 'object',
                        title: 'Class',
                        required: ['name'],
                        properties: {
                          name: {
                            type: 'string',
                            title: 'Name'
                          },
                          species: {
                            type: 'string',
                            title: 'Species'
                          }
                        }
                      },
                      owners: {
                        type: 'string',
                        title: 'The Owners'
                      }
                    }
                  }
                }
              }
            }
          end
        end
        let(:valid_project_data) do
          {
            pairs: [{
              class: { name: 'Jaguar', species: 'cat' },
              owners: 'Harry and Sally'
            }]
          }
        end
        let(:invalid_project_data) do
          {
            pairs: [{
              class: { species: 'dog' }
            }]
          }
        end
        let(:invalid_project_data_paths) { [[:pairs, 0, :class, :name], [:pairs, 0, :owners]] }
        let(:invalid_project_data_pretty_paths) { [['The Pairs', 'Class', 'Name'], ['The Pairs', 'The Owners']] }
      end

      context 'Example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                dogKennels: {
                  type: 'array',
                  title: 'Dog Kennels',
                  items: {
                    title: 'Dog House',
                    type: 'object',
                    properties: {
                      dogPlanning: {
                        type: 'object',
                        title: 'Dog Planning',
                        properties: {
                          dogPlanningNotGranted: {
                            type: 'object',
                            title: 'Dog Planning Not Granted',
                            properties: {
                              dogInAHat: {
                                type: 'object',
                                title: 'Its a dog in a hat',
                                required: ['hat'],
                                properties: {
                                  hat: {
                                    type: 'string',
                                    title: 'What a crazy hat'
                                  }
                                }
                              }
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
        end
        let(:valid_project_data) do
          {
            dogKennels: [
              {
                dogPlanning: {
                  dogPlanningNotGranted: {
                    dogInAHat: {
                      hat: 'Oh my, what a hat'
                    }
                  }
                }
              },
              {
                dogPlanning: {
                  dogPlanningNotGranted: {
                    dogInAHat: {
                      hat: 'Dog'
                    }
                  }
                }
              }
            ]
          }
        end
        let(:invalid_project_data) do
          {
            dogKennels: [
              {
                dogPlanning: {
                  dogPlanningNotGranted: {
                    dogInAHat: {
                      hat: 'Oh my, what a hat'
                    }
                  }
                }
              },
              {
                dogPlanning: {
                  dogPlanningNotGranted: {
                    dogInAHat: {
                    }
                  }
                }
              }
            ]
          }
        end
        let(:invalid_project_data_paths) do
          [[:dogKennels, 1, :dogPlanning, :dogPlanningNotGranted, :dogInAHat, :hat]]
        end
        let(:invalid_project_data_pretty_paths) do
          [['HIF Project', 'Dog Kennels', 'Dog House', 'Dog Planning', 'Dog Planning Not Granted', 'Its a dog in a hat']]
        end
      end
    end

    context 'required field in a dependency' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                goodDog: {
                  type: 'string',
                  title: 'Is this a good dog?',
                  enum: %w[Yes No]
                }
              },
              dependencies: {
                goodDog: {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['No']
                        }
                      }
                    },
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['Yes']
                        },
                        planningSubmitted: {
                          type: 'object',
                          title: 'Planning Submitted',
                          properties: {
                            dogs: {
                              title: 'Dogs',
                              type: 'string'
                            }
                          },
                          required: ['dogs']
                        }
                      }
                    }
                  ]
                }
              }
            }
          end
        end
        let(:valid_project_data) { { goodDog: 'Yes', planningSubmitted: {dogs: 'woof'} } }
        let(:invalid_project_data) {{ goodDog: 'Yes', planningSubmitted: {}}}
        let(:invalid_project_data_paths) { [[:planningSubmitted, :dogs]] }
        let(:invalid_project_data_pretty_paths) { [['Planning Submitted', 'Dogs']] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                goodDog: {
                  type: 'string',
                  title: 'Is this a good dog?',
                  enum: %w[Yes No]
                }
              },
              dependencies: {
                goodDog: {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['No']
                        }
                      }
                    },
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['Yes']
                        },
                        planningSubmitted: {
                          type: 'string',
                          title: 'Planning'
                        },
                        doggywalked: {
                          type: 'string',
                          title: 'Doggy Walks'
                        }
                      },
                      required: ['doggywalked']
                    }
                  ]
                }
              }
            }
          end
        end
        let(:valid_project_data) { { goodDog: 'Yes', doggywalked: 'woof', planningSubmitted: 'Ok' } }
        let(:invalid_project_data) {{ goodDog: 'Yes', planningSubmitted: 'ok'}}
        let(:invalid_project_data_paths) { [[:doggywalked]] }
        let(:invalid_project_data_pretty_paths) { [['Doggy Walks']] }
      end
    end

    context 'two required fields in a dependency' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                goodDog: {
                  type: 'string',
                  title: 'Is this a good dog?',
                  enum: %w[Yes No]
                }
              },
              dependencies: {
                goodDog: {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['No']
                        }
                      }
                    },
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['Yes']
                        },
                        planningSubmitted: {
                          type: 'object',
                          title: 'Planning Submitted',
                          properties: {
                            dogs: {
                              title: 'Dogs',
                              type: 'string'
                            },
                            puppies: {
                              title: 'Puppies',
                              type: 'string'
                            }
                          },
                          required: ['dogs', 'puppies']
                        }
                      }
                    }
                  ]
                }
              }
            }
          end
        end
        let(:valid_project_data) { { goodDog: 'Yes', planningSubmitted: {dogs: 'woof', puppies: 'aawhhooo'} } }
        let(:invalid_project_data) {{ goodDog: 'Yes', planningSubmitted: {}}}
        let(:invalid_project_data_paths) { [[:planningSubmitted, :dogs], [:planningSubmitted, :puppies]] }
        let(:invalid_project_data_pretty_paths) { [['Planning Submitted', 'Dogs'], ['Planning Submitted', 'Puppies']] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                goodDog: {
                  type: 'string',
                  title: 'Is this a good dog?',
                  enum: %w[Yes No]
                }
              },
              dependencies: {
                goodDog: {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['No']
                        }
                      }
                    },
                    {
                      type: 'object',
                      properties: {
                        goodDog: {
                          enum: ['Yes']
                        },
                        planningSubmitted: {
                          type: 'string',
                          title: 'Planning'
                        },
                        doggywalked: {
                          type: 'string',
                          title: 'Doggy Walks'
                        },
                        puppywalked: {
                          type: 'string',
                          title: 'Puppy Walks'
                        }
                      },
                      required: ['doggywalked', 'puppywalked']
                    }
                  ]
                }
              }
            }
          end
        end
        let(:valid_project_data) { { goodDog: 'Yes', doggywalked: 'woof', puppywalked: 'owwoo', planningSubmitted: 'Ok' } }
        let(:invalid_project_data) {{ goodDog: 'Yes', planningSubmitted: 'ok'}}
        let(:invalid_project_data_paths) { [[:doggywalked], [:puppywalked]] }
        let(:invalid_project_data_pretty_paths) { [['Doggy Walks'], ['Puppy Walks']] }
      end
    end

    context 'nested required field in a dependency' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                whatDogs: {
                  type: 'object',
                  title: 'What Dogs?',
                  properties: {
                    goodDog: {
                      type: 'string',
                      title: 'Is this a good dog?',
                      enum: %w[Yes No]
                    }
                  },
                  dependencies: {
                    goodDog: {
                      oneOf: [
                        {
                          type: 'object',
                          properties: {
                            goodDog: {
                              enum: ['No']
                            }
                          }
                        },
                        {
                          type: 'object',
                          properties: {
                            goodDog: {
                              enum: ['Yes']
                            },
                            planningSubmitted: {
                              type: 'object',
                              title: 'Planning Submitted',
                              properties: {
                                dogs: {
                                  title: 'Dogs',
                                  type: 'string'
                                }
                              },
                              required: ['dogs']
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
        end
        let(:valid_project_data) { {whatDogs: { goodDog: 'Yes', planningSubmitted: {dogs: 'woof'} }} }
        let(:invalid_project_data) {{whatDogs: { goodDog: 'Yes', planningSubmitted: {}}}}
        let(:invalid_project_data_paths) { [[:whatDogs, :planningSubmitted, :dogs]] }
        let(:invalid_project_data_pretty_paths) { [['What Dogs?', 'Planning Submitted', 'Dogs']] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                animalKingdom: {
                  type: 'object',
                  title: 'Animal Kingdom',
                  properties: {
                    acat: {
                      type: 'object',
                      title: 'Cat',
                      properties: {
                        needed: {
                          type: 'string',
                          title: 'Cat nip'
                        },
                        notneeded: {
                          type: 'string'
                        }
                      },
                      required: ['needed']
                    },
                    anotherDog: {
                      type: 'object',
                      title: 'Another Dog',
                      properties: {
                        goodDog: {
                          type: 'string',
                          title: 'Is this a good dog?',
                          enum: %w[Yes No]
                        }
                      },
                      dependencies: {
                        goodDog: {
                          oneOf: [
                            {
                              type: 'object',
                              properties: {
                                goodDog: {
                                  enum: ['No']
                                },
                                ifApplciable: {
                                  type: 'string',
                                  title: 'Not Neccessarily'
                                }
                              }
                            },
                            {
                              type: 'object',
                              properties: {
                                goodDog: {
                                  enum: ['Yes']
                                },
                                planningSubmitted: {
                                  type: 'string',
                                  title: 'Planning'
                                },
                                doggywalked: {
                                  type: 'string',
                                  title: 'Doggy Walks'
                                }
                              },
                              required: ['doggywalked']
                            }
                          ]
                        }
                      }
                    }
                  }
                }
              }
            }
          end
        end
        let(:valid_project_data) do 
          {
            animalKingdom: {
              anotherDog: { goodDog: 'No'},
              acat: { needed: 'Im here' }
            }
          }
        end
        let(:invalid_project_data) { { animalKingdom: { anotherDog: { goodDog: 'Yes'}, acat: {} }} }
        let(:invalid_project_data_paths) { [[:animalKingdom, :anotherDog, :doggywalked], [:animalKingdom, :acat, :needed]] }
        let(:invalid_project_data_pretty_paths) { [['Animal Kingdom', 'Another Dog', 'Doggy Walks'], ['Animal Kingdom', 'Cat', 'Cat nip']] }
      end
    end

    context 'required field in a dependency thats in an array' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'array',
              items: {
                type: 'object',
                title: 'Array Item',
                properties: {
                  goodDog: {
                    type: 'string',
                    title: 'Is this a good dog?',
                    enum: %w[Yes No]
                  }
                },
                dependencies: {
                  goodDog: {
                    oneOf: [
                      {
                        type: 'object',
                        properties: {
                          goodDog: {
                            enum: ['No']
                          }
                        }
                      },
                      {
                        type: 'object',
                        properties: {
                          goodDog: {
                            enum: ['Yes']
                          },
                          planningSubmitted: {
                            type: 'object',
                            title: 'Planning Submitted',
                            properties: {
                              dogs: {
                                title: 'Dogs',
                                type: 'string'
                              }
                            },
                            required: ['dogs']
                          }
                        }
                      }
                    ]
                  }
                }
              }
            }
          end
        end
        let(:valid_project_data) { [{ goodDog: 'Yes', planningSubmitted: {dogs: 'woof'} }] }
        let(:invalid_project_data) {[{ goodDog: 'Yes', planningSubmitted: {}}, { goodDog: 'Yes', planningSubmitted: {dogs: 'woof'}}, { goodDog: 'Yes', planningSubmitted: {}}]}
        let(:invalid_project_data_paths) { [[0, :planningSubmitted, :dogs], [2, :planningSubmitted, :dogs]] }
        let(:invalid_project_data_pretty_paths) { [['Array Item 1', 'Planning Submitted', 'Dogs'], ['Array Item 3', 'Planning Submitted', 'Dogs']] }
      end
    end

    context 'given null data' do 
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['catsComplete'],
                  properties: {
                    catsComplete: {
                      type: 'string',
                      title: 'cats compete on the beach to complete the complex beat'
                    }
                  }
                }
              }
            }
          end
        end

        let(:valid_project_data) do
          {
            planning: {
              catsComplete: '99'
            }
          }
        end

        let(:invalid_project_data) { { planning: { catsComplete: nil } } }
        let(:invalid_project_data_paths) { [%i[planning catsComplete]] }
        let(:invalid_project_data_pretty_paths) { [['Planning', 'Cats Complete']] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['train'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['catsComplete'],
                  properties: {
                    catsComplete: {
                      type: 'string',
                      title: 'cats compete on the beach to complete the complex beat'
                    },
                    dogComplete: {
                      type: 'string',
                      title: 'Dog Complete',
                      required: ['anotherDog', 'oneMoreDog'],
                      properties: {
                        anotherDog: {
                          type: 'string',
                          title: 'Another Dog'
                        },
                        thisDog: {
                          type: 'string',
                          title: 'This Dog'
                        },
                        oneMoreDog: {
                          type: 'string',
                          title: 'One More Dog'
                        }
                      }
                    }
                  }
                },
                train: {
                  title: 'Train',
                  type: 'string'
                },
                car: {
                  title: 'Car',
                  type: 'string'
                }
              }
            }
          end
        end

        let(:valid_project_data) do
          {
            planning: {
              catsComplete: '99',
              dogComplete: {
                anotherDog: '23',
                oneMoreDog: '3'
              }
            },
            train: 'A train'
          }
        end

        let(:invalid_project_data) do 
          {
            planning: {
              catsComplete: nil,
              dogComplete: {
                anotherDog: nil,
                thisDog: nil
              }
            },
            train: nil,
            car: 'broom'
          }
        end

        let(:invalid_project_data_paths) { [%i[planning catsComplete], %i[planning dogComplete anotherDog], %i[planning dogComplete oneMoreDog], %i[train]] }
        let(:invalid_project_data_pretty_paths) do
          [
            ['Planning', 'Cats Complete'],
            ['Planning', 'Dog Complete', 'Another Dog'],
            ['Planning', 'Dog Complete', 'One More Dog'],
            ['Train']
          ]
        end
      end

      context 'example 3 - an array' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                planning: {
                  type: 'array',
                  title: 'Planning',
                  items: {
                    type: 'object',
                    title: 'item',
                    required: ['catsComplete'],
                    properties: {
                      catsComplete: {
                        type: 'string',
                        title: 'cats compete on the beach to complete the complex beat'
                      }
                    }
                  }
                }
              }
            }
          end
        end

        let(:valid_project_data) do
          {
            planning: [{
              catsComplete: '99'
            }]
          }
        end

        let(:invalid_project_data) { { planning: [{ catsComplete: nil }] } }
        let(:invalid_project_data_paths) { [[:planning, 0, :catsComplete]] }
        let(:invalid_project_data_pretty_paths) { [['Planning', 'Item 1', 'cats compete on the beach to complete the complex beat']] }
      end
    end
  end
end
