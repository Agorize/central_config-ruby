# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '`central_flag?` helper', :stub_flagr, type: :integration do
  it 'works' do
    visit '/flag'
    expect(page).to have_content('Working')
  end
end
