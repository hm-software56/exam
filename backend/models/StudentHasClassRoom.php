<?php

namespace app\models;

use Yii;
use \app\models\base\StudentHasClassRoom as BaseStudentHasClassRoom;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "student_has_class_room".
 */
class StudentHasClassRoom extends BaseStudentHasClassRoom
{

    public function behaviors()
    {
        return ArrayHelper::merge(
            parent::behaviors(),
            [
                # custom behaviors
            ]
        );
    }

    public function rules()
    {
        return ArrayHelper::merge(
            parent::rules(),
            [
                # custom validation rules
            ]
        );
    }
}
