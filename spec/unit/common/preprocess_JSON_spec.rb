describe Common::PreprocessJSON do
  context 'Can convert a JSON with newlines into a JSON with escaped newlines' do
    example 1 do
      parsed_json = described_class.parse('
{
  "my_example_string": "some example
text with new
lines
"
}
')
      expect(parsed_json).to eq(
        {
          my_example_string: "some example\ntext with new\nlines\n"
        }
      )
    end

    example 2 do
      parsed_json = described_class.parse('
{
  "main_text": "some text",
  "a_key": "
 a set
  of
   more complex
    values
",
  "final_key": "Other text"
}
')
      expect(parsed_json).to eq(
        {
          main_text: "some text",
          a_key: "\n a set\n  of\n   more complex\n    values\n",
          final_key: "Other text"
        }
      )
    end
  end
end
