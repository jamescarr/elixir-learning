defmodule Pento.FAQTest do
  use Pento.DataCase

  alias Pento.FAQ

  describe "questions" do
    alias Pento.FAQ.Question

    import Pento.FAQFixtures

    @invalid_attrs %{title: nil, body: nil, votes: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert FAQ.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert FAQ.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{title: "some title", body: "some body", votes: 42}

      assert {:ok, %Question{} = question} = FAQ.create_question(valid_attrs)
      assert question.title == "some title"
      assert question.body == "some body"
      assert question.votes == 42
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FAQ.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body", votes: 43}

      assert {:ok, %Question{} = question} = FAQ.update_question(question, update_attrs)
      assert question.title == "some updated title"
      assert question.body == "some updated body"
      assert question.votes == 43
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = FAQ.update_question(question, @invalid_attrs)
      assert question == FAQ.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = FAQ.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> FAQ.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = FAQ.change_question(question)
    end
  end
end
