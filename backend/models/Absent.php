<?php

namespace app\models;

use Yii;
use \app\models\base\Absent as BaseAbsent;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "absent".
 */
class Absent extends BaseAbsent
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
