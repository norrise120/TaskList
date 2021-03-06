require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
                completion_date: Time.now + 5.days
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Could not find task with id: -1"
    end
  end

  describe "new" do
    it "can get the new task page" do
      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completion_date: nil,
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completion_date).must_equal task_hash[:task][:completion_date]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      #Arrange
      task_data = {
        name: "Edit test",
        description: "build a test for the edit method",
        completion_date: nil,
      }

      #Act
      get edit_task_path(task.id), params: task_data

      #Assert
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do
      #Act
      get edit_task_path(-1)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Could not find task with id: -1"
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      id = Task.first.id

      task_data = {
        name: "Edit test",
        description: "build a test for the edit method",
        completion_date: nil,
      }

      expect {
        patch task_path(id), params: task_data
      }.wont_change "Task.count"

      must_respond_with :redirect
      must_redirect_to task_path

      task = Task.find_by(id: id)
      expect(task.name).must_equal task_data[:name]
      expect(task.description).must_equal task_data[:description]
    end

    it "will redirect to the root page if given an invalid id" do
      id = -1

      task_data = {
        name: "Edit test",
        description: "build a test for the edit method",
        completion_date: nil,
      }

      patch task_path(id), params: task_data

      must_respond_with :redirect
      expect(flash[:error]).must_equal "Could not find task with id: -1"
    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    # Your tests go here
    it "removes the task from the database" do
      #Arrange
      task_data = {
        name: "Delete test",
        description: "build a test for the delete method",
        completion_date: nil,
      }

      task = Task.create(task_data)
      id = task.id

      #Act
      expect {
        delete task_path(id), params: task_data
      }.must_change "Task.count", -1

      #Assert
      must_respond_with :redirect
      must_redirect_to tasks_path

      after_task = Task.find_by(id: id)
      expect(after_task).must_be_nil
    end

    it "returns responds with redirect if the task does not exist" do
      #Arrange
      task_id = -1

      #Assumptions
      expect(Task.find_by(id: task_id)).must_be_nil

      #Act
      expect {
        delete task_path(task_id)
      }.wont_change "Task.count"

      #Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Could not find task with id: -1"
    end
  end

  # Complete for Wave 4
  describe "toggle_complete" do
    it "updates the task with the completion time when marked complete" do
      id = Task.first.id

      expect {
        patch toggle_complete_task_path(id)
      }.wont_change "Task.count"

      must_respond_with :redirect
      must_redirect_to tasks_path

      task = Task.find_by(id: id)
      expect(task.completion_date).wont_be_nil
    end

    it "updates the task with nil completion time when unmarked complete" do
      id = Task.first.id
      task = Task.find_by(id: id)

      patch toggle_complete_task_path(id) if task.completion_date == nil

      expect {
        patch toggle_complete_task_path(id)
      }.wont_change "Task.count"

      must_respond_with :redirect
      must_redirect_to tasks_path

      task = Task.find_by(id: id)
      expect(task.completion_date).must_be_nil
    end
  end
end
