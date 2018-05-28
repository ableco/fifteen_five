module FifteenFive
  class Group < ApiResource
    # Collect the user IDs out of the +members+ Array of URLs.
    #
    # Return Array of String user IDs.
    def user_ids
      @user_ids ||= extract_ids_from(members)
    end
  end
end
