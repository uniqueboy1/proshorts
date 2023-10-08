import express from "express";
import ProfileController from "../controllers/profile_controller.js";

let profileRouter = express.Router();

let profileController = new ProfileController();

profileRouter.post("/add_profile", profileController.addProfile);
profileRouter.get("/all_profiles", profileController.allProfiles);
profileRouter.get("/read_profile/:id", profileController.readProfilesById);
profileRouter.get(
  "/read_profile_by_field/:field/:value",
  profileController.readProfilesByField
);
profileRouter.put("/edit_profile/:id", profileController.editProfilesById);
profileRouter.delete(
  "/delete_profile/:id",
  profileController.deleteProfilesById
);
profileRouter.get("/search_profile", profileController.searchQuery);
profileRouter.get("/filter_profile", profileController.filterQuery);
profileRouter.get(
  "/check_field_existance/:field/:value",
  profileController.checkFieldExistance
);

export default profileRouter;
