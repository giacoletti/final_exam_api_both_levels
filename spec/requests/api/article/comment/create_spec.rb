RSpec.describe 'POST /api/articles/:id/comments', type: :request do
  subject { response }

  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let!(:article) { create(:article) }

  describe 'as an authenticated user' do
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
        expect(response_json['comment']['body']).to eq 'What an interesting article!'
      end
    end
    
    describe 'unsuccessfully' do
      describe 'due to invalid article id' do
        before do
          post "/api/articles/ASOIJDSAOIJ/comments", params: {
            comment: {
              body: 'What an interesting article!'
            }
          }, headers: credentials
        end

        it { is_expected.to have_http_status :not_found }
        
        it 'is expected to respond with an error message' do
          expect(response_json['message']).to eq 'Article not found'
        end
      end

      describe 'due to missing comment param' do
        before do
          post "/api/articles/#{article.id}/comments", params: {}, headers: credentials
        end

        it { is_expected.to have_http_status :unprocessable_entity }

        it 'is expected to respond with an error message' do
          expect(response_json['message']).to eq 'Comment param is missing'
        end
      end

      describe 'due to empty comment body param' do
        before do
          post "/api/articles/#{article.id}/comments", params: {
            comment: { body: '' }
          }, headers: credentials
        end

        it { is_expected.to have_http_status :unprocessable_entity }

        it 'is expected to respond with an error message' do
          expect(response_json['message']).to eq "Comment body can't be empty"
        end
      end
    end
  end

  describe 'as an anonymous user' do
    before do
      post "/api/articles/#{article.id}/comments", params: {
        comment: {
          body: 'What an interesting article!'
        }
      }, headers: nil
    end

    it { is_expected.to have_http_status :unauthorized }

    it 'is expected to respond with an error message' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end
end
