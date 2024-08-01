defmodule PentoWeb.QuestionLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pento.FAQFixtures

  @create_attrs %{title: "some title", body: "some body", votes: 42}
  @update_attrs %{title: "some updated title", body: "some updated body", votes: 43}
  @invalid_attrs %{title: nil, body: nil, votes: nil}

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end

  describe "Index" do
    setup [:create_question, :register_and_log_in_user]

    test "lists all questions", %{conn: conn, question: question} do
      {:ok, _index_live, html} = live(conn, ~p"/faq")

      assert html =~ "Listing Questions"
      assert html =~ question.title
    end

    test "saves new question", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/faq")

      assert index_live |> element("a", "New Question") |> render_click() =~
               "New Question"

      assert_patch(index_live, ~p"/faq/new")

      assert index_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#question-form", question: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/faq")

      html = render(index_live)
      assert html =~ "Question created successfully"
      assert html =~ "some title"
    end

    test "updates question in listing", %{conn: conn, question: question} do
      {:ok, index_live, _html} = live(conn, ~p"/faq")

      assert index_live |> element("#questions-#{question.id} a", "Edit") |> render_click() =~
               "Edit Question"

      assert_patch(index_live, ~p"/faq/#{question}/edit")

      assert index_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#question-form", question: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/faq")

      html = render(index_live)
      assert html =~ "Question updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes question in listing", %{conn: conn, question: question} do
      {:ok, index_live, _html} = live(conn, ~p"/faq")

      assert index_live |> element("#questions-#{question.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#questions-#{question.id}")
    end
  end

  describe "Show" do
    setup [:create_question, :register_and_log_in_user]

    test "displays question", %{conn: conn, question: question} do
      {:ok, _show_live, html} = live(conn, ~p"/faq/#{question}")

      assert html =~ "Show Question"
      assert html =~ question.title
    end

    test "updates question within modal", %{conn: conn, question: question} do
      {:ok, show_live, _html} = live(conn, ~p"/faq/#{question}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Question"

      assert_patch(show_live, ~p"/faq/#{question}/show/edit")

      assert show_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#question-form", question: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/faq/#{question}")

      html = render(show_live)
      assert html =~ "Question updated successfully"
      assert html =~ "some updated title"
    end
  end
end
