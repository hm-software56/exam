<?php

namespace app\controllers;
use \app\models\Profile;
use \app\models\User;
use \app\models\ClassRoom;
use \app\models\Student;
use Yii;
use yii\web\UploadedFile;
class ApiController extends \yii\web\Controller
{
    public $enableCsrfValidation = false;

    public function beforeAction($action)
    {
        $this->layout = "blank";
        \Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        if (\Yii::$app->request->get('lang')) {
            \Yii::$app->language = \Yii::$app->request->get('lang');
        }

        return parent::beforeAction($action); // TODO: Change the autogenerated stub
    }

    public function actionApitoken()
    {
        \Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        $token = \Yii::$app->getSecurity()->generatePasswordHash(\Yii::$app->params['key_token']);
        return $token;
    }

    public function actionSubmitsignup(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $profile=new Profile();
        $user=new User();
        $profile->first_name=Yii::$app->request->post('first_name');
        $profile->last_name=Yii::$app->request->post('last_name');
        $profile->phone=Yii::$app->request->post('phone');
        $profile->email=Yii::$app->request->post('email');
        if($profile->save()){
            $user->profile_id=$profile->id;
            $user->username=Yii::$app->request->post('username');
            $user->password=Yii::$app->getSecurity()->generatePasswordHash(Yii::$app->request->post('password'));
            $user->save();
        }
        $result=['profile'=>$profile,'user'=>$user];
        return $result;
    }
    public function actionLogin()
    {
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $result=[];
        $user=User::find()->where(['username'=>Yii::$app->request->post('username'),'status'=>1])->one();
        if($user)
        {
            if (Yii::$app->getSecurity()->validatePassword(Yii::$app->request->post('password'), $user->password)) {
                $result=$user;
            }
        }
        
        return $result;
    }

    public function actionAddclassroom(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $cl=new ClassRoom();
        $result=[];
        $cl->class_room_name=Yii::$app->request->post('class_room_name');
        $cl->teacher_id=Yii::$app->request->post('teacher_id');
        if($cl->save()){
            $result=$cl;
        }
        return $result;
    }
    public function actionEditclassroom(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $cl=ClassRoom::find()->where(['teacher_id'=>Yii::$app->request->post('teacher_id'),'id'=>Yii::$app->request->post('id')])->one();
        $result=[];
        $cl->class_room_name=Yii::$app->request->post('class_room_name');
        $cl->teacher_id=Yii::$app->request->post('teacher_id');
        if($cl->save()){
            $result=$cl;
        }
        return $result;
    }
    public function actionListclassroom(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $cl=ClassRoom::find()->where(['teacher_id'=>Yii::$app->request->post('teacher_id')])->all();
        return $cl;
    }

    public function actionDeleteclassroom(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $cl=ClassRoom::find()->where(['teacher_id'=>Yii::$app->request->post('teacher_id'),'id'=>Yii::$app->request->post('id')])->one();
        $result=[];
        if($cl->delete()){
            $result=[true];
        }
        return $result;
    }

    public function actionListstudent(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $st=Student::find()->where(['class_room_id'=>Yii::$app->request->post('class_room_id')])->all();
        return $st;
    }
    public function actionAddstudent(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $st=new Student();
        $result=[];
        $st->class_room_id=Yii::$app->request->post('class_room_id');
        $st->student_code=Yii::$app->request->post('student_code');
        $st->first_name=Yii::$app->request->post('first_name');
        $st->last_name=Yii::$app->request->post('last_name');
        if($st->save()){
            $result=$st;
        }
        return $result;
    }
    public function actionEditstudent(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $st=Student::find()->where(['id'=>Yii::$app->request->post('id')])->one();
        $result=[];
        $st->class_room_id=Yii::$app->request->post('class_room_id');
        $st->student_code=Yii::$app->request->post('student_code');
        $st->first_name=Yii::$app->request->post('first_name');
        $st->last_name=Yii::$app->request->post('last_name');
        if($st->save()){
            $result=$st;
        }
        return $result;
    }
    public function actionDeletestudent(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }
        $st=Student::find()->where(['id'=>Yii::$app->request->post('id')])->one();
        $result=[];
        if($st->delete()){
            $result=[true];
        }
        $this->CountStudent(Yii::$app->request->post('class_room_id'));
        return $result;
    }
    public function actionImportcsv(){
        $token = $this->checkToken(\Yii::$app->request->post('tokenID'));
        if ($token['id'] == false) {
            return $token;
        }

        $upload = UploadedFile::getInstanceByName("upfile");
        if (empty($upload)) {
            return "Must upload at least 1 file in upfile form-data POST";
        }else{
            $realFileName = rand(). time() . '.' . $upload->extension;
            $path = \Yii::$app->basePath . '/web/file/' . $realFileName;
            if ($upload->saveAs($path)) {
                $data = \moonland\phpexcel\Excel::import($path);
                foreach($data as $list){
                    $st=Student::find()->where(['student_code'=>(string)$list['student_code'],'class_room_id'=>Yii::$app->request->post('class_room_id')])->one();
                    if(empty($st))
                    {
                        $st=new Student();
                    }
                    $st->class_room_id=Yii::$app->request->post('class_room_id');
                    $st->student_code=(string)$list['student_code'];
                    $st->first_name=$list['first_name'];
                    $st->last_name=$list['last_name'];
                    $st->save();
                }
                unlink($path);
                $this->CountStudent(Yii::$app->request->post('class_room_id'));
            }
        }
        return $st;
    }
    public function CountStudent($class_room_id){
        $student=Student::find()->where(['class_room_id'=>$class_room_id])->all();
        $cl=ClassRoom::find()->where(['id'=>$class_room_id])->one();
        $cl->count_student=count($student);
        $cl->save();
    }
    public function checkToken($tokenID)
    {
        if ($tokenID) {
            $token = \Yii::$app->getSecurity()->validatePassword(\Yii::$app->params['key_token'], $tokenID);
            if ($token == false) {
                return ['id' => false, 'msg_wrong' => 'Validate token wrong.!'];
            } else {
                return ['id' => true, 'msg_wrong' => 'Validate token success'];
            }
        } else {
            return ['id' => false, 'msg_wrong' => 'No token access.!'];
        }
    }
    public function actionIndex()
    {
        return $this->render('index');
    }

}
