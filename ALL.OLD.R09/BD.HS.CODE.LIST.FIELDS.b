*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.HS.CODE.LIST.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type       :
*Attached To           :
*Attached As           : ROUTINE
*Developed by          :
*Designation           :
*Email                 : smortoza@fortress-global.com
*Incoming Parameters   :
*Outgoing Parameters   :
*-----------------------------------------------------------------------------
* Modification History :
* 1)
*    Date : 02/07/2020
*    Modification Description : Description filed modify and add SPCL.PRMSN.CLAUSE
*    Modified By  : erian@fortress-global.com
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("HS.CODE", "") ;* Define Table id
    ID.N = '10'; ID.T = ''
*-----------------------------------------------------------------------------
*1/E----Modification End
    CALL Table.addFieldDefinition('XX.DESCRIPTION','65','A','');* Add a new field
*1/E----Modification End
    CALL Table.addFieldDefinition("STATUS", "10", "":FM:"RESTRICTED_PROHIBITED", "")
*1/S----Modification Start
    CALL Table.addFieldDefinition("SPCL.PRMSN.CLAUSE", "65", "A", "")
    CALL Table.addFieldDefinition("RECORD.STATE", "8", "":FM:"ACTIVE_INACTIVE", "")
*1/E----Modification End
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
