*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.SOC.BALINFO.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.SOC.BALINFO.FIELDS
*Developer Info:
*    Date         : 20/02/2022
*    Description  : Template BD.SOC.BALINFO
*    Developed By : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $USING EB.SystemTables
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
    ID.T < 4 > = "#############-####"
*-----------------------------------------------------------------------------

    CALL Table.addField("HIGH.DATE",T24_Date,"","")
    CALL Table.addField("HIGH.BALANCE",T24_Numeric,"","")
    CALL Table.addField("LOW.DATE",T24_Date,"","")
    CALL Table.addField("LOW.BALANCE", T24_Numeric,"","")
    CALL Table.addField("XX<AVERAGE.DATE",T24_Date,"","")
    CALL Table.addField("XX>AVERAGE.BALANCE", T24_Numeric, "","")
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')


****************
*    CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*    CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
