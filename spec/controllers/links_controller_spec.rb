# frozen_string_literal: true

describe LinksController, type: :controller, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'when the user is the author of the resource' do
      before { login(author) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }
          .to change(question.links, :count)
                .by(-1)
      end

      it 'renders the destroy view' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when the user is not the author of the resource' do
      before { login(user) }

      it 'does not delete the link and responses :forbidden' do
        expect { delete :destroy, params: { id: link } }
          .not_to change(question.links, :count)

        expect(response.status).to be 403
      end
    end

    context 'when the user is the guest of the resource' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: link }, format: :js }
          .not_to change(question.links, :count)
      end

      it 'responses :unauthorized' do
        delete :destroy, params: { id: link }, format: :js

        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'

        expect(response.status).to be 401
      end
    end
  end
end
