var express = require("express")
var app = express()
var exec = require('child_process').exec,child;

app.set("views", __dirname+'/views')
app.set("view engine", "ejs")

app.use(express.json())
app.use(express.urlencoded({extended:false}))

// localhost:3000 접속시 메인 화면 출력
app.get("/", function(req, res){
    res.render("index.ejs")
})

app.post("/rdata", function(req, res){
    console.log(req.body)
    var a = req.body.file_path;
    var b = req.body.subject;
    var c = req.body.score;

    // R 파일 실행
    var cmd = "Rscript ./public/rscripts/test.R " + a.toString() + " " + b.toString() + " " + c.toString();

    exec(cmd, function(error, result, srderr){
        if(error){
            console.error(error);
            return;
        }
        // R 실행 결과 값을 출력
        res.send(result)
    })
})

// R markdown으로 만든 문서 로드
// 서버 실행 후 localhost:3000/test 로 접속 시 
app.get("/test", function(req, res){
    res.render('test.ejs')
})


app.listen(3000, function(){
    console.log("서버 시작")
})