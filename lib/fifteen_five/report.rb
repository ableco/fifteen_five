module FifteenFive
  class Report < ApiResource
    # Assign `user` to `user_id` so we don't get confused that it's a full
    # user record and not just an ID.
    #
    # Return Integer user IDs.
    def user_id
      @user_id ||= extract_id_from(user)
    end
  end
end
