describe LocalAuthority::UseCase::GetReturnTemplatePathTypes do
  let(:template_schema) { {} }

  let(:template_gateway_spy) { spy(find_by: found_template) }
  let(:usecase) { described_class.new }

  context 'simple schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          submissionEstimated: 'baseline data to be copied',
          type: 'object',
          grantEstimated: 'baseline data baseline data to be copied',
          properties:
          {
            noise: {}
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: [:noise])[:path_types]
        expect(path_types).to eq(%i[object object])
      end

      it 'cant find an invalid path' do
        path_types = usecase.execute(schema: template_schema, path: [:paws])[:path_types]
        expect(path_types).to eq(%i[object not_found])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          submissionEstimated: 'baseline data to be copied',
          type: 'object',
          grantEstimated: 'baseline data baseline data to be copied',
          properties:
          {
            dog: {}
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: [:dog])[:path_types]
        expect(path_types).to eq(%i[object object])
      end

      it 'cant find an invalid path' do
        path_types = usecase.execute(schema: template_schema, path: [:cats])[:path_types]
        expect(path_types).to eq(%i[object not_found])
      end
    end
  end

  context 'deep schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            cat: {
              type: 'object',
              properties: {
                noise: {
                  type: 'object',
                  properties: {
                    averageAmplitude: {}
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[cat noise averageAmplitude])[:path_types]
        expect(path_types).to eq(%i[object object object object])
      end

      it 'cant find an invalid path' do
        path_types = usecase.execute(schema: template_schema, path: %i[cat noise averagePitch])[:path_types]
        expect(path_types).to eq(%i[object object object not_found])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dog: {
              type: 'object',
              properties: {
                noise: {
                  type: 'object',
                  properties: {
                    averageAmplitude: {
                      type: 'object',
                      precision: {}
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[dog noise averageAmplitude])[:path_types]
        expect(path_types).to eq(%i[object object object object])
      end

      it 'cant find an invalid path' do
        path_types = usecase.execute(schema: template_schema, path: %i[cat tail wag])[:path_types]
        expect(path_types).to eq(%i[object not_found])
      end
    end
  end

  context 'simple array schema' do
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
                  noise: {}
                }
              }
            }
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[dog noise])[:path_types]
        expect(path_types).to eq(%i[object array object])
      end

      it 'cant find an invalid path' do
        path_types = usecase.execute(schema: template_schema, path: %i[dog tail])[:path_types]
        expect(path_types).to eq(%i[object not_found])
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
                  noise: {}
                }
              }
            }
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[cat noise])[:path_types]
        expect(path_types).to eq(%i[object array object])
      end

      it 'cant find an invalid path' do
        path_types = usecase.execute(schema: template_schema, path: %i[cat tail])[:path_types]
        expect(path_types).to eq(%i[object not_found])
      end
    end
  end

  context 'simple dependency schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          submissionEstimated: 'baseline data to be copied',
          type: 'object',
          grantEstimated: 'baseline data baseline data to be copied',
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
                    cat: {}
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[cat])[:path_types]
        expect(path_types).to eq(%i[object object])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          submissionEstimated: 'baseline data to be copied',
          type: 'object',
          grantEstimated: 'baseline data baseline data to be copied',
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
                    dog: {}
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[dog])[:path_types]
        expect(path_types).to eq(%i[object object])
      end
    end
  end

  context 'complex dependency schema with array' do
    context 'example 1' do
      let(:template_schema) do
        {
          submissionEstimated: 'baseline data to be copied',
          type: 'object',
          grantEstimated: 'baseline data baseline data to be copied',
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
                          noise: {}
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

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[cat noise])[:path_types]
        expect(path_types).to eq(%i[object array object])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          submissionEstimated: 'baseline data to be copied',
          type: 'object',
          grantEstimated: 'baseline data baseline data to be copied',
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
                          sound: {}
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

      it 'gets the correct path types' do
        path_types = usecase.execute(schema: template_schema, path: %i[dog sound])[:path_types]
        expect(path_types).to eq(%i[object array object])
      end
    end
  end
end
