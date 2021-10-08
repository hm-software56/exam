<?php
// This class was automatically generated by a giiant build task
// You should not change it manually as it will be overwritten on next build

namespace app\models\base;

use Yii;

/**
 * This is the base-model class for table "exam".
 *
 * @property integer $id
 * @property string $start_time
 * @property string $end_time
 * @property string $time_answer
 * @property string $url_answer
 * @property integer $subject_id
 *
 * @property \app\models\Question[] $questions
 * @property \app\models\Subject $subject
 * @property string $aliasModel
 */
abstract class Exam extends \yii\db\ActiveRecord
{



    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'exam';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['start_time', 'end_time', 'time_answer'], 'safe'],
            [['time_answer', 'url_answer', 'subject_id'], 'required'],
            [['subject_id'], 'integer'],
            [['url_answer'], 'string', 'max' => 255],
            [['subject_id'], 'exist', 'skipOnError' => true, 'targetClass' => \app\models\Subject::className(), 'targetAttribute' => ['subject_id' => 'id']]
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => Yii::t('models', 'ID'),
            'start_time' => Yii::t('models', 'Start Time'),
            'end_time' => Yii::t('models', 'End Time'),
            'time_answer' => Yii::t('models', 'Time Answer'),
            'url_answer' => Yii::t('models', 'Url Answer'),
            'subject_id' => Yii::t('models', 'Subject ID'),
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getQuestions()
    {
        return $this->hasMany(\app\models\Question::className(), ['exam_id' => 'id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getSubject()
    {
        return $this->hasOne(\app\models\Subject::className(), ['id' => 'subject_id']);
    }




}
