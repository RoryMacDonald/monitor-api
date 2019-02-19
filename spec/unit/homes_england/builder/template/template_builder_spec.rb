# frozen_string_literal: true

describe HomesEngland::Builder::Template::TemplateBuilder do
  let(:template_builder) { described_class.new }

  it 'returns template object when hif requested' do
    expect(template_builder.build_template(type: 'hif').class).to eq(Common::Domain::Template)
  end

  it 'returns template object when ac requested' do
    expect(template_builder.build_template(type: 'ac').class).to eq(Common::Domain::Template)
  end

  it 'returns template object when ff requested' do
    expect(template_builder.build_template(type: 'ff').class).to eq(Common::Domain::Template)
  end

  it 'returns nil object when unknown is requested' do
    expect(template_builder.build_template(type: 'I like chicken, I like liver, MeowMix, MeowMix, please deliver')).to be_nil
  end
end
