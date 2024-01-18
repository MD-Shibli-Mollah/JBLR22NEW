*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.SCHEDULE.CHARGE.INFO.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.SCHEDULE.CHARGE.INFO.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
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
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("XX<BASE.BALANCE", T24_Numeric, "", "")
    CALL Table.addField("XX-TOTAL.CHARGE.AMOUNT", T24_Numeric, "", "")
    CALL Table.addField("XX-TOTAL.VAT.AMOUNT", T24_Numeric, "", "")
    CALL Table.addField("XX-TOTAL.REALIZE.AMOUNT", T24_Numeric, "", "")
    CALL Table.addField("XX-TOTAL.REALIZE.VAT", T24_Numeric, "", "")
    CALL Table.addField("XX-TOTAL.DUE.AMT", T24_Numeric, "", "")
    CALL Table.addField("XX-TOTAL.DUE.VAT", T24_Numeric, "", "")
    CALL Table.addField("XX-XX.TXN.REF", T24_String, "", "")
    CALL Table.addField("XX-XX.TXN.AMOUNT", T24_String, "", "")
    CALL Table.addField("XX>STATUS", T24_String, "", "")
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
