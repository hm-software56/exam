<?php

namespace app\models;

use Yii;
use \app\models\base\TypeActivity as BaseTypeActivity;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "type_activity".
 */
class TypeActivity extends BaseTypeActivity
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
