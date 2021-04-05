# frozen_string_literal: true

shared_examples_for 'voted' do
  let!(:model) { described_class.controller_name.classify.constantize }
  let!(:votable) { create(model.to_s.underscore.to_sym) }

  let!(:voter) { create(:user) }
  let!(:authored) { create(model.to_s.underscore.to_sym, user: voter) }

  describe 'PATCH #vote_up' do
    context 'when the user is not the author' do
      before { login(voter) }

      it 'assigns the requested resource to @votable' do
        patch :vote_up, params: { id: votable }

        expect(assigns(:votable)).to eq(votable)
      end

      it 'sets a new value for rating by vote up' do
        expect { patch :vote_up, params: { id: votable, format: :json } }
          .to change(votable, :rating)
                .by(1)
      end

      it 'returns JSON response' do
        patch :vote_up, params: { id: votable, format: :json }

        response_body_keys = JSON.parse(response.body).keys

        expect(response_body_keys).to eq %w[id name rating]
      end

      context 'with tries to vote twice' do
        before { patch :vote_up, params: { id: votable } }

        specify do
          expect { patch :vote_up, params: { id: votable, format: :json } }
            .not_to change(votable, :rating)
        end
      end
    end

    context 'when the user is the author' do
      before { login(voter) }

      it 'tries to set vote' do
        expect { patch :vote_up, params: { id: authored, format: :json } }
          .not_to change(votable, :rating)
      end

      it 'returns the error response' do
        patch :vote_up, params: { id: authored, format: :json }

        expect(response.status).to eq 403

        response_error_message = JSON.parse(response.body)['message']

        expect(response_error_message).to eq 'You do not have permissions to vote!'
      end
    end

    context 'when the user is unauthorized' do
      it 'does not set a new value for rating by vote up' do
        expect { patch :vote_up, params: { id: votable, format: :json } }
          .not_to change(votable, :rating)
      end

      it 'returns the error response' do
        patch :vote_up, params: { id: votable, format: :json }

        expect(response.status).to eq 401

        response_error = JSON.parse(response.body)['error']

        expect(response_error).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'when the user is not the author' do
      before { login(voter) }

      it 'assigns the requested resource to @votable' do
        patch :vote_down, params: { id: votable }

        expect(assigns(:votable)).to eq(votable)
      end

      it 'sets a new value for rating by vote down' do
        expect { patch :vote_down, params: { id: votable, format: :json } }
          .to change(votable, :rating)
                .by(-1)
      end

      it 'returns JSON response' do
        patch :vote_down, params: { id: votable, format: :json }

        response_body_keys = JSON.parse(response.body).keys

        expect(response_body_keys).to eq %w[id name rating]
      end

      context 'with tries to vote twice' do
        before { patch :vote_down, params: { id: votable } }

        specify do
          expect { patch :vote_down, params: { id: votable, format: :json } }
            .not_to change(votable, :rating)
        end
      end
    end

    context 'when the user is the author' do
      before { login(voter) }

      it 'does not set a new value for rating by vote down' do
        expect { patch :vote_down, params: { id: authored, format: :json } }
          .not_to change(votable, :rating)
      end

      it 'returns the error response' do
        patch :vote_down, params: { id: authored, format: :json }

        expect(response.status).to eq 403

        response_error_message = JSON.parse(response.body)['message']

        expect(response_error_message).to eq 'You do not have permissions to vote!'
      end
    end

    context 'when the user is unauthorized' do
      it 'does not sets a new value for rating by vote down' do
        expect { patch :vote_down, params: { id: votable, format: :json } }
          .not_to change(votable, :rating)
      end

      it 'returns the error response' do
        patch :vote_down, params: { id: votable, format: :json }

        expect(response.status).to eq 401

        response_error = JSON.parse(response.body)['error']

        expect(response_error).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'DELETE #revoke_vote' do
    context 'when the user is not an author' do
      before { login(voter) }

      it 'assigns the requested resource to @votable' do
        delete :revoke_vote, params: { id: votable }

        expect(assigns(:votable)).to eq(votable)
      end

      it 'revokes the vote' do
        patch :vote_up, params: { id: votable, format: :json }

        expect { delete :revoke_vote, params: { id: votable, format: :json } }
          .to change(votable, :rating)
                .from(1)
                .to(0)
      end

      it 'returns JSON response' do
        patch :revoke_vote, params: { id: votable, format: :json }

        response_body_keys = JSON.parse(response.body).keys

        expect(response_body_keys).to eq %w[id name rating]
      end
    end

    context 'when the author of the resource' do
      before { login(voter) }

      context 'with tries to revoke the vote' do
        it 'does not change the rating of the resource' do
          patch :vote_up, params: { id: authored, format: :json }

          expect { delete :revoke_vote, params: { id: authored, format: :json } }
            .not_to change(votable, :rating)
        end

        it 'returns the error response' do
          delete :revoke_vote, params: { id: authored, format: :json }

          expect(response.status).to eq 403

          response_error_message = JSON.parse(response.body)['message']

          expect(response_error_message).to eq 'You do not have permissions to vote!'
        end
      end
    end

    context 'when the user is unauthorized' do
      context 'with tries to revoke the vote' do
        it 'does not change the rating of the resource' do
          expect { delete :revoke_vote, params: { id: votable, format: :json } }
            .not_to change(votable, :rating)
        end

        it 'returns the error response' do
          delete :revoke_vote, params: { id: votable, format: :json }

          expect(response.status).to eq 401

          response_error = JSON.parse(response.body)['error']

          expect(response_error).to eq 'You need to sign in or sign up before continuing.'
        end
      end
    end
  end
end
