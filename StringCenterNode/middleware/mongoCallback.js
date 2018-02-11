function mongoCallback(err, res){
  if(err){
    console.log("ERROR ON CALLBACK" + err);
  } else{
    console.log("successful");
  }
}


module.exports = {cb : mongoCallback};
