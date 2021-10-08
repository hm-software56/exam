<?php

namespace app\models;

use Yii;
use \app\models\base\Exam as BaseExam;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "exam".
 */
class Exam extends BaseExam
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
