# frozen_string_literal: true

RSpec.describe '`central_setting` helper', :stub_flagr, type: :integration do
  it 'works' do
    visit '/setting'
    expect(page).to have_content('Agorize')
  end
end
