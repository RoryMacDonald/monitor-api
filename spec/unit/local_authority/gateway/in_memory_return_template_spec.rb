describe LocalAuthority::Gateway::InMemoryReturnTemplate do
  let(:hif_returns_schema_spy) { spy }
  let(:ac_returns_schema_spy) { spy }

  def get_template(type:)
    described_class.new(
      hif_returns_schema: hif_returns_schema_spy,
      ac_returns_schema: ac_returns_schema_spy
    ).find_by(type: type)
  end

  it 'returns a template when given type hif' do
    get_template(type: 'hif')
    expect(hif_returns_schema_spy).to have_received(:execute)
  end

  it 'returns a template when given type ac' do
    get_template(type: 'ac')
    expect(ac_returns_schema_spy).to have_received(:execute)
  end

  it 'returns nil when not given type hif' do
    expect(get_template(type: 'Hi')).to be_nil
  end
end
