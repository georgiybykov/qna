# frozen_string_literal: true

shared_examples_for 'commented' do
  let(:model) { described_class.controller_name.classify.constantize }
  let(:commentable) { create(model.to_s.underscore.to_sym) }

  let(:user) { create(:user) }

  describe 'POST #comment' do
    context 'when the user is authenticated' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment to the database' do
          expect { post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :js }
            .to change(Comment, :count)
                  .by(1)
        end

        it 'renders the comment template' do
          post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :js

          expect(response).to render_template 'comments/create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect do
            post :comment, params: { id: commentable, comment: attributes_for(:comment, :invalid) }, format: :js
          end
            .not_to change(commentable.comments, :count)
        end

        it 'renders the comment template' do
          post :comment, params: { id: commentable, comment: attributes_for(:comment, :invalid) }, format: :js

          expect(response).to render_template 'comments/create'
        end
      end
    end

    context 'when the user is the guest of the resource' do
      it 'does not save the comment' do
        expect { post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :js }
          .not_to change(commentable.comments, :count)
      end

      it 'responses :unauthorized' do
        post :comment, params: { id: commentable, comment: attributes_for(:comment) }, format: :js

        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'

        expect(response.status).to be 401
      end
    end
  end
end
