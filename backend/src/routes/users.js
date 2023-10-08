import express from "express";
import UsersController from "../controllers/users_controller.js";

let usersRouter = express.Router();

let usersController = new UsersController();

usersRouter.post("/add_user", usersController.addUser);
usersRouter.get("/all_users", usersController.allUsers);
usersRouter.get("/following_videos/:id", usersController.followingVideos);
usersRouter.get("/check_value_in_array/:field/:value", usersController.checkValueInArray);
usersRouter.get("/read_user/:id", usersController.readUserById);
usersRouter.get("/return_user_field/:search_field/:search_value/:return_field", usersController.returnUserField);
usersRouter.get("/check_value_exist_in_array/:userId/:field/:key/:checkValue/", usersController.checkValueExistInArray);
usersRouter.get("/read_user_by_field/:field/:value", usersController.readUserByField);
// usersRouter.get("/read_user_by_two_field/:field1/:value1/:field2/:value2", usersController.readUserByTwoField);
usersRouter.put("/edit_user/:id", usersController.editUserById);
usersRouter.put("/edit_user_array_field/:id/:field", usersController.editUserArrayField);
usersRouter.put("/update_array_field/:userId/:field1/:field2/:updateId", usersController.updateArrayField);
usersRouter.put("/delete_user_array_field/:id/:field", usersController.deleteUserArrayField);
usersRouter.delete("/delete_user/:id", usersController.deleteUserById);
usersRouter.get("/search_user", usersController.searchQuery);
usersRouter.get("/top_user", usersController.topUser);
usersRouter.get("/filter_user", usersController.filterQuery);

export default usersRouter;
