# frozen_string_literal: true

class HomesEngland::Builder::Template::Templates::FFTemplate
  def self.create
    ff_template = Common::Domain::Template.new
    ff_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'FF Project',
      type: 'object',
      properties: {
        infrastructures: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              sectionA: {
                type: 'object',
                properties: {
                  information: {
                    type: 'string'
                  }
                }
              }
            }
          }
        },
        demolitionRemediation: demolition_and_remediation
      }
    }

    ff_template
  end

  def self.demolition_and_remediation
    {
      type: 'object',
      title: 'Demolition and Remediation',
      properties: {
        demolition: {
          type: 'object',
          title: 'Demolition',
          properties: {
            demolitionRequired: {
              type: 'string',
              title: 'Demolition Required?',
              radio: true,
              enum: %w[Yes No]
            }
          },
          dependencies: {
            demolitionRequired: {
              oneOf: [
                {
                  properties: {
                    demolitionRequired: {
                      enum: ['Yes']
                    },
                    demolitionSummary: {
                      type: 'string',
                      title: 'Summary of Demolition Required',
                      extendedText: true
                    },
                    sitesAffected: {
                      type: 'array',
                      title: 'Sites Affected',
                      addable: true,
                      items: {
                        type: 'object',
                        properties: {
                          site: {
                            type: 'string',
                            title: 'Site'
                          }
                        }
                      }
                    },
                    completion: {
                      type: 'object',
                      title: 'Demolition Completion',
                      properties: {
                        demolitionCompletion: {
                          type: 'string',
                          format: 'date',
                          title: 'Baseline Completion Date'
                        },
                        demolitionCriticalPath: {
                          type: 'string',
                          title: 'Summary of Critical Path',
                          extendedText: 'true'
                        }
                      }
                    }
                  }
                },
                {
                  properties: {
                    demolitionRequired: {
                      enum: ['No']
                    }
                  }
                }
              ]
            }
          }
        },
        remidiation: {
          type: 'object',
          title: 'Remidiation',
          properties: {
            remediationRequired: {
              type: 'string',
              title: 'Remidiation Required?',
              radio: true,
              enum: %w[Yes No]
            }
          },
          dependencies: {
            remediationRequired: {
              oneOf: [
                {
                  properties: {
                    remediationRequired: {
                      enum: ['Yes']
                    },
                    areaToRemidiate: {
                      type: 'string',
                      title: 'Area to be remediated'
                    },
                    remidiationSummary: {
                      type: 'string',
                      title: 'Summary of remediation required'
                    },
                    sitesAffected: {
                      type: 'array',
                      title: 'Sites Affected',
                      addable: true,
                      items: {
                        type: 'object',
                        properties: {
                          site: {
                            type: 'string',
                            title: 'Site'
                          }
                        }
                      }
                    },
                    completion: {
                      type: 'object',
                      title: 'Remediation Completion',
                      properties: {
                        remediationCompletion: {
                          type: 'string',
                          format: 'date',
                          title: 'Baseline Completion Date'
                        },
                        remediationCriticalPath: {
                          type: 'string',
                          title: 'Summary of Critical Path',
                          extendedText: 'true'
                        }
                      }
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
