# frozen_string_literal: true

describe AttachmentsController, type: :controller, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:resource) { create(:answer, :with_file, user: author) }

  describe 'DELETE #destroy' do
    context 'when the user is the author of the resource' do
      before { login(author) }

      it 'deletes the attachment' do
        expect { delete :destroy, params: { id: resource }, format: :js }
          .to change(resource.files, :count)
                .by(-1)
      end

      it 'renders the destroy view' do
        delete :destroy, params: { id: resource }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when the user is not the author of the resource' do
      before { login(user) }

      it 'does not delete the resource and responses :forbidden' do
        expect { delete :destroy, params: { id: resource }, format: :js }
          .not_to change(resource.files, :count)

        expect(response.status).to be 403
      end
    end

    context 'when the user is the guest' do
      it 'does not delete the resource' do
        expect { delete :destroy, params: { id: resource }, format: :js }
          .not_to change(resource.files, :count)
      end

      it 'responses :unauthorized' do
        delete :destroy, params: { id: resource }, format: :js

        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'

        expect(response.status).to be 401
      end
    end
  end
end
