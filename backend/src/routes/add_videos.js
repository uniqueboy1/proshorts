import express from "express";
import AddVideoController from "../controllers/add_video_controller.js";

let videoRouter = express.Router();

let addVideoController = new AddVideoController();

videoRouter.post("/add_video", addVideoController.addVideo);
videoRouter.get("/all_videos", addVideoController.allVideos);
videoRouter.get("/read_video/:id", addVideoController.readVideoById);
videoRouter.get("/return_video_field/:search_field/:search_value/:return_field", addVideoController.returnVideoField);
videoRouter.get("/read_video_by_field/:field/:value", addVideoController.readVideoByField); 
videoRouter.get(
  "/read_video_by_two_field/:field1/:value1/:field2/:value2",
  addVideoController.readVideoByTwoField
);
videoRouter.get("/check_value_exist_in_array/:videoId/:field/:key/:checkValue/", addVideoController.checkValueExistInArray);
videoRouter.put("/edit_video/:id", addVideoController.editVideoById);
videoRouter.put("/edit_video_array_field/:id/:field", addVideoController.editVideoArrayField);
videoRouter.put("/update_array_field/:videoId/:field/:updateId", addVideoController.updateVideoArrayField);
videoRouter.put("/edit_video_array_array_field/:videoId/:fieldId/:field1/:field2", addVideoController.editVideoArrayArrayField);
videoRouter.put("/delete_video_array_field/:id/:field", addVideoController.deleteVideoArrayField);
videoRouter.delete("/delete_video/:id", addVideoController.deleteVideoById);
videoRouter.get("/search_video", addVideoController.searchQuery);
videoRouter.get("/top_videos", addVideoController.topVideos);
videoRouter.get("/filter_video", addVideoController.filterQuery);

export default videoRouter;
