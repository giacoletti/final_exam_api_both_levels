RSpec.describe 'POST /api/articles/:id/comments', type: :request do
  subject { response } 

  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let!(:article) { create(:article) }

  describe 'As an authenticated user' do
    describe 'successfully' do
      before do
        post "/api/articles/#{article.id}/comments", params: {
          comment: {
            body: 'What an interesting article!'
          }
        }, headers: credentials
      end

      it { is_expected.to have_http_status :created }

      it 'is expected to respond with saved comment' do
        binding.pry
        expect(response_json['comment']['body']).to eq 'What an interesting article!'
      end
    end
  end
end