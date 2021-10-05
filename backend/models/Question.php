<?php

namespace app\models;

use Yii;
use \app\models\base\Question as BaseQuestion;
use yii\helpers\ArrayHelper;

/**
 * This is the model class for table "question".
 */
class Question extends BaseQuestion
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
