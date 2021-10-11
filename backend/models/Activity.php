<?php

namespace app\models;

use Yii;
use \app\models\base\Activity as BaseActivity;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "activity".
 */
class Activity extends BaseActivity
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
