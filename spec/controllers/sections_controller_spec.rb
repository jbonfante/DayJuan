require 'spec_helper'

describe SectionsController do
  render_views

  describe 'index' do
    before do
      Section.create!(name: 'Baked Potato w/Cheese')
      Section.create!(name: 'Garlic Mashed Potatoes')
      Section.create!(name: 'Potatoes Au Gratin')
      Section.create!(name: 'Baked Brussel Sprouts')

      xhr :get, :index, format: :json, keywords: keywords
    end

    subject(:results){ JSON.parse(response.body)}

    def extract_name
      ->(object) { object['name'] }
    end

    context 'When the search finds results' do
      let(:keywords) { 'baked' }
      it 'should 200' do
        expect(response).to be_ok
      end

      it 'should return two results' do
        expect(results.size).to eq(2)
      end

      it "it should include 'Baked Potato w/Cheese'" do
        expect(results.map(&extract_name)).to include('Baked Potato w/Cheese')
      end

      it "it should include 'Baked Brussel Sprouts'" do
        expect(results.map(&extract_name)).to include('Baked Brussel Sprouts')
      end
    end

    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end
  end

  describe 'show' do
    before do
      xhr :get, :show, format: :json, id: section_id
    end

    subject(:results) { JSON.parse(response.body) }

    context 'when the section exists' do
      let(:section) { Section.create!(name: 'Baked Potato w/ Cheese',
                                      instructions: 'Nuke for 20 minutes; top with cheese')}
      let(:section_id) { section.id }

      it { expect(response).to be_ok }
      it { expect(results['id']).to eq(section_id) }
      it { expect(results['name']).to eq(section.name) }
      it { expect(results['instructions']).to eq(section.instructions) }
    end

    context 'when the section doesnt exist' do
      let(:section_id) { -9999 }
      it { expect(response).to be_not_found}
    end
  end

  describe 'create' do
    before do
      xhr :post, :create, format: :json, section: {name: 'Toast',
                                                   instructions: 'Add bread to toaster, push lever'}
    end
    it { expect(response.status).to eq(201) }
    it { expect(Section.last.name).to eq('Toast') }
    it { expect(Section.last.instructions).to eq('Add bread to toaster, push lever')}
  end

  describe 'update' do
    let(:section) {
      Section.create!(name: 'Baked Potato w/ Cheese',
                      instructions: 'Nuke for 20 minutes; top with cheese')
    }
    before do
      xhr :put, :update, format: :json, id: section.id, section: {name: 'Toast',
                                                                  instructions: 'Add bread to toaster, push lever' }
      section.reload
    end
    it { expect(response.status).to eq(204) }
    it { expect(section.name).to eq('Toast') }
    it { expect(section.instructions).to eq('Add bread to toaster, push lever') }
  end

  describe 'destroy' do
    let(:section_id){
      Section.create!(name: 'Baked Potato w/ Cheese', instructions: 'Nuke for 20 minutes; top with cheese').id
    }

    before do
      xhr :delete, :destroy, format: :json, id: section_id
    end
    it { expect(response.status).to eq(204) }
    it { expect(Section.find_by_id(section_id)).to be_nil }
  end

end
