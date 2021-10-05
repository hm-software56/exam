<?php

namespace app\models;

use Yii;
use \app\models\base\Student as BaseStudent;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "student".
 */
class Student extends BaseStudent
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
