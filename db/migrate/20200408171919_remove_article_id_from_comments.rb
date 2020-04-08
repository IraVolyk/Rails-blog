class RemoveArticleIdFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_reference :comments, :article, null: false, foreign_key: true
  end
end
