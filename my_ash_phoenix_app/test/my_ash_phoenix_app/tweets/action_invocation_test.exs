defmodule MyAshPhoenixApp.Tweets.ActionInvocationTest do
  use ExUnit.Case
  import ExUnitProperties
  alias MyAshPhoenixApp.Tweets.{Domain, Tweet}


  describe "valid inputs" do
    # now if our action inputs are invalid when we think they should be valid, we will find out here
    property "accepts all valid input" do
      user = Domain.create_user!()

      check all(input <- Ash.Generator.action_input(Tweet, :create)) do
        {text, other_inputs} = Map.pop!(input, :text)

        assert Domain.changeset_to_create_tweet(
                 text,
                 other_inputs,
                 authorize?: false,
                 actor: user
               ).valid?
      end
    end

    # same as the above, but actually call the action. This tests the underlying action implementation
    # not just initial validation
    property "succeeds on all valid input" do
      user = Domain.create_user!()

      check all(input <- Ash.Generator.action_input(Tweet, :create)) do
        {text, other_inputs} = Map.pop!(input, :text)
        Domain.create_tweet!(text, other_inputs, authorize?: false, actor: user)
      end
    end

    test "can tweet some specific text, in addition to any other valid inputs" do
      user = Domain.create_user!()

      check all(
              input <- Ash.Generator.action_input(Tweet, :create, %{text: "some specific text"})
            ) do
        {text, other_inputs} = Map.pop!(input, :text)
        Domain.create_tweet!(text, other_inputs, actor: user)
      end
    end
  end

  describe "authorization" do
    test "allows a user to update their own tweet" do
      user = Domain.create_user!()
      tweet = Domain.create_tweet!("Hello world!", actor: user)

      assert Domain.can_update_tweet?(user, tweet, "Goodbye world!")
    end

    test "does not allow a user to update someone elses tweet" do
      user = Domain.create_user!()
      user2 = Domain.create_user!()
      tweet = Domain.create_tweet!("Hello world!", actor: user)

      refute Domain.can_update_tweet?(user2, tweet, "Goodbye world!")
    end

    test "allows an admin user to update someone elses tweet" do
      user = Domain.create_user!()
      user2 = Domain.create_user!(%{admin?: true})
      tweet = Domain.create_tweet!("Hello world!", actor: user)

      assert Domain.can_update_tweet?(user2, tweet, "Goodbye world!")
    end
  end

  describe "calculations" do
    test "text length calculation computes the length of the text" do
      user = Domain.create_user!()
      tweet = Domain.create_tweet!("Hello world!", actor: user)
      assert Ash.calculate!(tweet, :tweet_length) == 12
    end
  end
end

