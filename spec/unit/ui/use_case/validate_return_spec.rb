# frozen_string_literal: true

describe UI::UseCase::ValidateReturn do
  let(:project_type) { 'hif' }
  let(:invalid_return_data_pretty_paths) { nil }

  # We need to write this as a fake that iterates through invalid_return_data_pretty_paths
  # This needs to be reset every time
  let(:get_return_template_path_titles_spy) do
    Class.new do
      attr_reader :called_with

      def initialize(invalid_return_data_pretty_paths)
        @called_with = []
        @invalid_return_data_pretty_paths = invalid_return_data_pretty_paths
      end

      def execute(argument)
        @called_with << argument
        { path_titles: @invalid_return_data_pretty_paths.shift }
      end
    end.new(invalid_return_data_pretty_paths.dup)
  end

  let(:template) do
    Common::Domain::Template.new.tap do |p|
      p.schema = {}
    end
  end

  let(:invalid_return_data_paths) { [] }

  let(:return_template_gateway_spy) { double(find_by: template) }
  let(:use_case) do
    described_class.new(return_template_gateway: return_template_gateway_spy, get_return_template_path_titles: get_return_template_path_titles_spy)
  end

  it 'should have accept project type and return data' do
    use_case.execute(type: project_type, return_data: {})
  end

  context 'calling return template gateway' do
    context 'example 1' do
      let(:project_type) { 'cats' }
      it 'should call return template gateway with type' do
        use_case.execute(type: project_type, return_data: {})
        expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
      end
    end

    context 'example 2' do
      let(:project_type) { 'dogs' }
      it 'should call return template gateway with type' do
        use_case.execute(type: project_type, return_data: {})
        expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
      end
    end
  end

  shared_examples_for 'required field validation' do
    context 'given a valid return' do
      it 'should return a hash with a valid field as true' do
        return_value = use_case.execute(type: project_type, return_data: valid_return_data)
        expect(return_value[:valid]).to eq(true)
      end

      it 'should have no paths' do
        return_value = use_case.execute(type: project_type, return_data: valid_return_data)
        expect(return_value[:invalid_paths]).to eq([])
      end

      it 'should return no pretty paths' do
        return_value = use_case.execute(type: project_type, return_data: valid_return_data)
        expect(return_value[:pretty_invalid_paths]).to eq([])
      end
    end

    context 'given an invalid return' do
      it 'should return a hash with a valid field as false' do
        return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
        expect(return_value[:valid]).to eq(false)
      end

      it 'should return the correct path' do
        return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
        expect(return_value[:invalid_paths]).to match_array(invalid_return_data_paths)
      end

      it 'should return the correct pretty path' do
        return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
        expect(return_value[:pretty_invalid_paths]).to match_array(invalid_return_data_pretty_paths)
      end
    end

    context 'calling titles use case' do
      it 'should call get return template path titles with type and path' do
        use_case.execute(type: project_type, return_data: invalid_return_data)

        call_arguments = invalid_return_data_paths.map do |path|
          { path: path, schema: template.schema }
        end
        expect(get_return_template_path_titles_spy.called_with).to match_array(call_arguments)
      end
    end
  end

  context 'required field validation' do
    context 'single field' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['percentComplete'],
              properties: {
                percentComplete: {
                  type: 'integer',
                  title: 'Percent complete'
                }
              }
            }
          end
        end

        let(:valid_return_data) do
          {
            percentComplete: 99
          }
        end

        let(:invalid_return_data) do
          {

          }
        end

        let(:invalid_return_data_paths) do
          [[:percentComplete]]
        end

        let(:invalid_return_data_pretty_paths) do
          [['Percent complete']]
        end
      end

      context 'example 2' do
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

        let(:valid_return_data) do
          {
            catsComplete: 'The Cat Plan'
          }
        end

        let(:invalid_return_data) do
          {

          }
        end

        let(:invalid_return_data_paths) do
          [[:catsComplete]]
        end

        let(:invalid_return_data_pretty_paths) do
          [['cats compete on the beach to complete the complex beat']]
        end
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
                  required: ['percentComplete'],
                  properties: {
                    percentComplete: {
                      type: 'integer',
                      title: 'Percent complete'
                    }
                  }
                }
              }
            }
          end
        end

        let(:valid_return_data) do
          {
            planning: {
              percentComplete: 99
            }
          }
        end

        let(:invalid_return_data) do
          {
            planning: {

            }
          }
        end

        let(:invalid_return_data_paths) { [%i[planning percentComplete]] }

        let(:invalid_return_data_pretty_paths) do
          [['Planning', 'Percent complete']]
        end
      end

      context 'example 2' do
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

        let(:valid_return_data) do
          {
            planning: {
              catsComplete: 'The Cat Plan'
            }
          }
        end

        let(:invalid_return_data) do
          {
            planning: {}
          }
        end

        let(:invalid_return_data_paths) { [%i[planning catsComplete]] }

        let(:invalid_return_data_pretty_paths) do
          [['Planning', 'cats compete on the beach to complete the complex beat']]
        end
      end
    end

    context 'given a nested field with an array' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['cats'],
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
                cats: {
                  type: 'array',
                  title: 'Wearing hats',
                  minItems: 1,
                  items: {
                    type: 'object',
                    title: 'Cats',
                    properties: {
                      name: {
                        type: 'string',
                        title: 'Cat Name'
                      }
                    }
                  }
                }
              }
            }
          end
        end

        let(:invalid_return_data) { {} }

        let(:valid_return_data) do
          {
            cats: [{ name: 'Love the hats' }]
          }
        end

        let(:invalid_return_data_paths) { [[:cats]] }

        let(:invalid_return_data_pretty_paths) do
          [['Cats', 'Cat Name']]
        end
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['dogs'],
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
                dogs: {
                  type: 'array',
                  title: 'Wearing caps',
                  minItems: 1,
                  items: {
                    name: {
                      type: 'string',
                      title: 'Dog Name'
                    }
                  }
                }
              }
            }
          end
        end
        let(:invalid_return_data) { {} }
        let(:valid_return_data) do
          {
            dogs: [{ name: 'Love the hats' }]
          }
        end

        let(:invalid_return_data_paths) { [[:dogs]] }

        let(:invalid_return_data_pretty_paths) do
          [['Planning', 'Wearing caps', 'Dog Name']]
        end
      end
    end

    context 'given an array with a nested invalid field' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['dogs'],
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
                dogs: {
                  type: 'array',
                  title: 'Wearing caps',
                  items: {
                    type: 'object',
                    required: ['name'],
                    properties:
                      {
                        name: {
                          type: 'string',
                          title: 'Dog Name'
                        }
                      }
                  }
                }
              }
            }
          end
        end

        let(:invalid_return_data) do
          {
            dogs: [{}]
          }
        end

        let(:valid_return_data) do
          {
            dogs: [{ name: 'Scout, The Dog.' }]
          }
        end

        let(:invalid_return_data_paths) { [[:dogs, 0, :name]] }

        let(:invalid_return_data_pretty_paths) do
          [['Planning', 'Wearing caps', 'Dog Name']]
        end
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['cats'],
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
                cats: {
                  type: 'array',
                  title: 'Wearing caps',
                  items: {
                    type: 'object',
                    required: ['catName'],
                    properties:
                      {
                        catName: {
                          type: 'string',
                          title: 'Cat Name'
                        }
                      }
                  }
                }
              }
            }
          end
        end

        let(:invalid_return_data) do
          {
            cats: [{ test: 'Hello' }]
          }
        end

        let(:valid_return_data) do
          {
            cats: [{ catName: 'Scout, The Cat.' }]
          }
        end

        let(:invalid_return_data_paths) { [[:cats, 0, :catName]] }

        let(:invalid_return_data_pretty_paths) do
          [['HIF Project', 'Wearing caps', 'Cat Name']]
        end
      end
    end

    context 'given a nested field with multiple entries' do
      context 'example 1' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['cats'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['percentComplete'],
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
                cats: {
                  type: 'string',
                  title: 'Wearing hats'
                }
              }
            }
          end
        end

        let(:valid_return_data) do
          {
            planning: {
              percentComplete: 99
            },
            cats: 'Love the hats'
          }
        end

        let(:invalid_return_data) do
          {
            planning: {
              notComplete: 'Cows'
            }
          }
        end

        let(:invalid_return_data_paths) { [[:cats], %i[planning percentComplete]] }

        let(:invalid_return_data_pretty_paths) do
          [['HIF Project', 'Wearing caps', 'Cat Name'], ['HIF Project', 'Planning', 'Percent Complete']]
        end

        context 'given partially invalid return' do
          let(:invalid_return_data) do
            {
              planning: {

                notComplete: 'Cows'
              },
              cats: 'To Be Valid'
            }
          end
          it 'should return a hash with a valid field as false' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['dogs'],
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
                    theAnswer: {
                      type: 'integer',
                      title: 'What is the answer to life, the universe and everything?'
                    }
                  }
                },
                dogs: {
                  title: 'Dogs R Us',
                  type: 'string'
                }
              }
            }
          end
        end

        let(:valid_return_data) do
          {
            planning: {
              catsComplete: 'The Cat Plan'
            },
            dogs: 'Scout, The Dog, was here'
          }
        end

        let(:invalid_return_data) do
          {
            planning: {
              theAnswer: 43
            }
          }
        end
        let(:invalid_return_data_paths) { [[:dogs], [:planning, :catsComplete]] }

        let(:invalid_return_data_pretty_paths) do
          [['HIF Project', 'Dogs R Us'], ['HIF Project', 'Planning', 'cats compete on the beach to complete the complex beat']]
        end
      end
    end

    context 'given a nested array with invalid entries' do
      context 'example 1' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                infrastructures: {
                  type: 'array',
                  title: 'Infrastructures',
                  items: {
                    title: 'Infrastructure',
                    type: 'object',
                    properties: {
                      planning: {
                        type: 'object',
                        title: 'Planning',
                        properties: {
                          planningNotGranted: {
                            type: 'object',
                            title: 'Planning Not Granted',
                            properties: {
                              fieldOne: {
                                type: 'object',
                                title: 'Planning Not Granted Field One',
                                required: ['percentComplete'],
                                properties: {
                                  percentComplete: {
                                    type: 'integer',
                                    title: 'Percent complete'
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

        let(:valid_return_data) do
          {
            infrastructures: [
              {
                summary: {
                  type: 'A House',
                  description: 'A house of cats'
                },
                planning: {
                  baselineOutlinePlanningPermissionGranted: true,
                  planningNotGranted: {
                    baselineSummaryOfCriticalPath: 'Summary of critical path',
                    fieldOne: {
                      baselineCompletion: {
                        baselineFullPlanningPermissionSubmitted: '2020-01-01',
                        baselineFullPlanningPermissionGranted: '2020-01-01'
                      },
                      fullPlanningPermissionGranted: false,
                      fullPlanningPermissionSummaryOfCriticalPath: 'Summary of critical path',
                      percentComplete: 8
                    }
                  }
                }
              }
            ]
          }
        end

        let(:invalid_return_data) do
          {
            infrastructures: [
              {
                summary: {
                  type: 'A House',
                  description: 'A house of cats'
                },
                planning: {
                  baselineOutlinePlanningPermissionGranted: true,
                  planningNotGranted: {
                    baselineSummaryOfCriticalPath: 'Summary of critical path',
                    fieldOne: {
                      baselineCompletion: {
                        baselineFullPlanningPermissionSubmitted: '2020-01-01',
                        baselineFullPlanningPermissionGranted: '2020-01-01'
                      },
                      fullPlanningPermissionGranted: false,
                      fullPlanningPermissionSummaryOfCriticalPath: 'Summary of critical path'
                    }
                  }
                }
              }
            ]
          }
        end

        let(:invalid_return_data_paths) do
          [[:infrastructures, 0, :planning, :planningNotGranted, :fieldOne, :percentComplete]]
        end

        let(:invalid_return_data_pretty_paths) do
          [['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning', 'Planning Not Granted', 'Planning Not Granted Field One', 'Percent Complete']]
        end
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'

        let(:template) do
          Common::Domain::Template.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                cathouses: {
                  type: 'array',
                  title: 'Cat Houses',
                  items: {
                    title: 'Cat House',
                    type: 'object',
                    properties: {
                      catPlanning: {
                        type: 'object',
                        title: 'Cat Planning',
                        properties: {
                          catPlanningNotGranted: {
                            type: 'object',
                            title: 'Cat Planning Not Granted',
                            properties: {
                              catInAHat: {
                                type: 'object',
                                title: 'Its a cat in a hat',
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
        let(:valid_return_data) do
          {
            cathouses: [
              {
                catPlanning: {
                  catPlanningNotGranted: {
                    catInAHat: {
                      hat: 'Oh my, what a hat'
                    }
                  }
                }
              },
              {
                catPlanning: {
                  catPlanningNotGranted: {
                    catInAHat: {
                      hat: 'Cat'
                    }
                  }
                }
              }
            ]
          }
        end

        let(:invalid_return_data) do
          {
            cathouses: [
              {
                catPlanning: {
                  catPlanningNotGranted: {
                    catInAHat: {
                      hat: 'Oh my, what a hat'
                    }
                  }
                }
              },
              {
                catPlanning: {
                  catPlanningNotGranted: {
                    catInAHat: {
                    }
                  }
                }
              }
            ]
          }
        end
      end
      let(:invalid_return_data_paths) do
        [[:cathouses, 1, :catPlanning, :catPlanningNotGranted, :catInAHat, :hat]]
      end

      let(:invalid_return_data_pretty_paths) do
        [['HIF Project', 'Cat Houses', 'Cat House', 'Cat Planning', 'Cat Planning Not Granted', 'Its a cat in a hat']]
      end
    end
  end

  context 'single dependency' do
    context 'example 1' do
      it_should_behave_like 'required field validation'

      let(:template) do
        Common::Domain::Template.new.tap do |p|
          p.schema = {
            title: 'HIF Project',
            type: 'object',
            properties: {
              percentComplete: {
                type: 'string',
                title: 'Percent complete',
                enum: %w[Yes No]
              }
            },
            dependencies: {
              percentComplete: {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      percentComplete: {
                        enum: ['No']
                      }
                    }
                  },
                  {
                    type: 'object',
                    properties: {
                      percentComplete: {
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

      let(:valid_return_data) do
        {
          percentComplete: 'Yes',
          planningSubmitted: { dogs: 'hi' }
        }
      end

      let(:invalid_return_data) { { percentComplete: 'Yes', planningSubmitted: {} } }
      let(:invalid_return_data_paths) { [[:planningSubmitted, :dogs]] }
      let(:invalid_return_data_pretty_paths) { [['Planning Submitted', 'Dogs']] }
    end
  end

  context 'complex dependencies' do
    context 'example 1' do
      it_should_behave_like 'required field validation'

      let(:template) do
        Common::Domain::Template.new.tap do |p|
          p.schema = {
            title: 'HIF Project',
            type: 'object',
            properties: {
              percentComplete: {
                type: 'string',
                title: 'Percent complete',
                enum: %w[Yes No]
              }
            },
            dependencies: {
              percentComplete: {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      percentComplete: {
                        enum: ['No']
                      },
                      anotherField: {
                        type: 'string'
                      }
                    },
                    required: ['anotherField']
                  },
                  {
                    type: 'object',
                    properties: {
                      percentComplete: {
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
                    },
                    required: ['planningSubmitted']
                  }
                ]
              }
            }
          }
        end
      end

      let(:valid_return_data) do
        {
          percentComplete: 'Yes',
          planningSubmitted: { dogs: 'hi' }
        }
      end

      let(:invalid_return_data) { { percentComplete: 'Yes', planningSubmitted: {} } }
      let(:invalid_return_data_paths) { [[:planningSubmitted, :dogs]] }
      let(:invalid_return_data_pretty_paths) { [['Planning Submitted', 'Dogs']] }
    end
  end

  context 'Minimum items in an array' do
    context 'example 1' do
      it_should_behave_like 'required field validation'
      let(:template) do
        Common::Domain::Template.new.tap do |p|
          p.schema = {
            title: 'HIF Project',
            type: 'object',
            required: ['cats'],
            properties: {
              cats: {
                type: 'array',
                title: 'Wearing hats',
                minItems: 1,
                items: {
                  type: 'object',
                  title: 'Cats',
                  properties: {
                    name: {
                      type: 'string',
                      title: 'Cat Name'
                    }
                  }
                }
              }
            }
          }
        end
      end

      let(:invalid_return_data) { { cats: [] } }

      let(:valid_return_data) do
        {
          cats: [{ name: 'Love the hats' }]
        }
      end

      let(:invalid_return_data_paths) { [[:cats]] }

      let(:invalid_return_data_pretty_paths) do
        [['Cats']]
      end
    end

    context 'example 2' do
      it_should_behave_like 'required field validation'
      let(:template) do
        Common::Domain::Template.new.tap do |p|
          p.schema = {
            title: 'HIF Project',
            type: 'object',
            required: ['cats'],
            properties: {
              cats: {
                type: 'array',
                title: 'Cat array',
                items: {
                  type: 'object',
                  title: 'Cats',
                  properties: {
                    toys: {
                      type: 'array',
                      title: 'Cat toys',
                      minItems: 1,
                      items: {
                        type: 'object',
                        properties: {
                          description: {
                            title: 'Description',
                            type: 'string'
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

      let(:invalid_return_data) { { cats: [{ toys: [] }] } }

      let(:valid_return_data) do
        {
          cats: [{ toys: [{ description: 'Fluffy mouse' }] }]
        }
      end

      let(:invalid_return_data_paths) { [[:cats, 0, :toys]] }

      let(:invalid_return_data_pretty_paths) do
        [['Cats', '0', 'Cat toys']]
      end
    end
  end
end
