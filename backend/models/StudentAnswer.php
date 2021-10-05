<?php

namespace app\models;

use Yii;
use \app\models\base\StudentAnswer as BaseStudentAnswer;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "student_answer".
 */
class StudentAnswer extends BaseStudentAnswer
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
