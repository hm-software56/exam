<?php
// This class was automatically generated by a giiant build task
// You should not change it manually as it will be overwritten on next build

namespace app\models\base;

use Yii;

/**
 * This is the base-model class for table "user".
 *
 * @property integer $id
 * @property string $username
 * @property string $password
 * @property integer $status
 * @property integer $profile_id
 *
 * @property \app\models\ClassRoom[] $classRooms
 * @property \app\models\Profile $profile
 * @property \app\models\Subject[] $subjects
 * @property string $aliasModel
 */
abstract class User extends \yii\db\ActiveRecord
{



    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'user';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['username', 'password', 'profile_id'], 'required'],
            [['status', 'profile_id'], 'integer'],
            [['username', 'password'], 'string', 'max' => 255],
            [['profile_id'], 'exist', 'skipOnError' => true, 'targetClass' => \app\models\Profile::className(), 'targetAttribute' => ['profile_id' => 'id']]
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => Yii::t('models', 'ID'),
            'username' => Yii::t('models', 'Username'),
            'password' => Yii::t('models', 'Password'),
            'status' => Yii::t('models', 'Status'),
            'profile_id' => Yii::t('models', 'Profile ID'),
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getClassRooms()
    {
        return $this->hasMany(\app\models\ClassRoom::className(), ['teacher_id' => 'id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProfile()
    {
        return $this->hasOne(\app\models\Profile::className(), ['id' => 'profile_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getSubjects()
    {
        return $this->hasMany(\app\models\Subject::className(), ['teacher_id' => 'id']);
    }




}
