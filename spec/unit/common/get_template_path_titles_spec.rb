# frozen_string_literal: true

describe Common::UseCase::GetTemplatePathTitles do
  let(:template_schema) { {} }
  let(:found_template) do
    Common::Domain::Template.new.tap do |t|
      t.schema = template_schema
    end
  end

  let(:use_case) { described_class.new }

  context 'simple schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'template',
          type: 'object',
          properties:
          {
            noise: {
              title: 'Noise'
            }
          }
        }
      end

      it 'gets the correct path names' do
        path_titles = use_case.execute(path: [:noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(%w[template Noise])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Head',
          type: 'object',
          properties:
          {
            dog: {
              title: 'Body'
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: [:dog], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(%w[Head Body])
      end
    end
  end

  context 'simple schema with missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'template',
          type: 'object',
          properties:
          {
            noise: {
            }
          }
        }
      end

      it 'gets the correct path names' do
        path_titles = use_case.execute(path: [:noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['template', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Head',
          type: 'object',
          properties:
          {
            dog: {
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: [:dog], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Head', '[dog]'])
      end
    end
  end

  context 'simple schema with missing top level titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            noise: {
            }
          }
        }
      end

      it 'gets the correct path names' do
        path_titles = use_case.execute(path: [:noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dog: {
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: [:dog], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]'])
      end
    end
  end

  context 'deep schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'Title',
          type: 'object',
          properties:
          {
            cat: {
              title: 'Cat Title',
              type: 'object',
              properties: {
                noise: {
                  title: 'Noise Title',
                  type: 'object',
                  properties: {
                    averageAmplitude: {
                      title: 'Average Amplitude Title'
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat noise averageAmplitude], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Title', 'Cat Title', 'Noise Title', 'Average Amplitude Title'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Cat',
          type: 'object',
          properties:
          {
            dog: {
              title: 'Dog',
              type: 'object',
              properties: {
                noise: {
                  title: 'Noise',
                  type: 'object',
                  properties: {
                    averageAmplitude: {
                      title: 'Average Amplitude',
                      type: 'object',
                      precision: {
                      }
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog noise averageAmplitude], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Cat', 'Dog', 'Noise', 'Average Amplitude'])
      end
    end
  end

  context 'simple array schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'cats',
          type: 'object',
          properties:
          {
            dog: {
              title: 'dogs',
              type: 'array',
              items: {
                title: 'doge',
                type: 'object',
                properties: {
                  noise: {
                    title: 'noise'
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: [:dog, 0, :noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['cats', 'dogs', 'doge 1', 'noise'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Top level',
          type: 'object',
          properties:
          {
            cat: {
              title: 'cat array',
              type: 'array',
              items: {
                title: 'cat item',
                type: 'object',
                properties: {
                  noise: {
                    title: 'noise'
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: [:cat, 1, :noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Top level', 'cat array', 'cat item 2', 'noise'])
      end
    end
  end

  context 'simple array schema with missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dog: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]', '[item]', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            cat: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]', '[item]', '[noise]'])
      end
    end
  end

  context 'simple array schema with some missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dog: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                    title: 'Hey'
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]', '[item]', 'Hey'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            cat: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]', '[item]', '[noise]'])
      end
    end
  end

  context 'top level array schema with some missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'array',
          title: 'Infras',
          items:
          {
            type: 'object',
            title: 'Infra',
            properties: {
              summary: {
                type: 'object',
                title: 'Summary'
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: [0, :summary], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Infras', 'Infra 1', 'Summary'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'array',
          title: 'Animals',
          items:
          {
            type: 'object',
            title: 'Dog',
            properties: {
              noise: {
                type: 'object',
                title: 'Noise'
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: [1, :noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Animals', 'Dog 2', 'Noise'])
      end
    end
  end

  context 'simple dependency schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'header',
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats'
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(%w[header Cats])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'cats',
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                      title: 'dog'
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(%w[cats dog])
      end
    end
  end

  context 'simple dependency schema without titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]'])
      end
    end
  end

  context 'complex dependency schema with array' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'Optional',
          type: 'object',
          properties:
          {
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats',
                      type: 'array',
                      items:
                      {
                        title: 'Cat',
                        type: 'object',
                        properties: {
                          noise: {
                            title: 'Noise'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(%w[Optional Cats Cat Noise])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Dog Header',
          type: 'object',
          properties:
          {
            dogs: {}
          },
          dependencies:
          {
            dogs:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                      title: 'Dogs',
                      type: 'array',
                      items:
                      {
                        title: 'Dog',
                        type: 'object',
                        properties: {
                          sound: {
                            title: 'Sound'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog sound], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Dog Header', 'Dogs', 'Dog', 'Sound'])
      end
    end
  end

  context 'complex dependency schema with multiple options for dependencies' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'Optional',
          type: 'object',
          properties:
          {
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats',
                      type: 'array',
                      items:
                      {
                        title: 'Cat',
                        type: 'object',
                        properties: {
                          noise: {
                            title: 'Noise'
                          }
                        }
                      }
                    }
                  }
                },
                {
                  type: 'object',
                  properties: {
                    dogs: {
                      title: 'Dogs',
                      type: 'array',
                      items:
                      {
                        title: 'Dogs',
                        type: 'object',
                        properties: {
                          noise: {
                            title: 'Dogs'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(%w[Optional Cats Cat Noise])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Dog Header',
          type: 'object',
          properties:
          {
            dogs: {}
          },
          dependencies:
          {
            dogs:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                      title: 'Dogs',
                      type: 'array',
                      items:
                      {
                        title: 'Dog',
                        type: 'object',
                        properties: {
                          sound: {
                            title: 'Sound'
                          }
                        }
                      }
                    }
                  }
                },
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats',
                      type: 'array',
                      items:
                      {
                        title: 'Cat',
                        type: 'object',
                        properties: {
                          sound: {
                            title: 'Sound'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog sound], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Dog Header', 'Dogs', 'Dog', 'Sound'])
      end
    end
  end

  context 'complex dependency schema with multiple dependencies' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'Optional',
          type: 'object',
          properties:
          {
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats',
                      type: 'array',
                      items:
                      {
                        title: 'Cat',
                        type: 'object',
                        properties: {
                          noise: {
                            title: 'Noise'
                          }
                        }
                      }
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
                    cat: {
                      title: 'Dogs',
                      type: 'array',
                      items:
                      {
                        title: 'Dog',
                        type: 'object',
                        properties: {
                          noise: {
                            title: 'Noise'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(%w[Optional Cats Cat Noise])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Dog Header',
          type: 'object',
          properties:
          {
            dogs: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats',
                      type: 'array',
                      items:
                      {
                        title: 'Cat',
                        type: 'object',
                        properties: {
                          sound: {
                            title: 'Sound'
                          }
                        }
                      }
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
                    dog: {
                      title: 'Dogs',
                      type: 'array',
                      items:
                      {
                        title: 'Dog',
                        type: 'object',
                        properties: {
                          sound: {
                            title: 'Sound'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog sound], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['Dog Header', 'Dogs', 'Dog', 'Sound'])
      end
    end
  end

  context 'complex dependency schema with array with missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      type: 'array',
                      items:
                      {
                        type: 'object',
                        properties: {
                          noise: {
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[cat noise], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]', '[item]', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dogs: {}
          },
          dependencies:
          {
            dogs:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                      type: 'array',
                      items:
                      {
                        type: 'object',
                        properties: {
                          sound: {
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(path: %i[dog sound], schema: template_schema)[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]', '[item]', '[sound]'])
      end
    end
  end
end
