* @ValidationCode : Mjo5NTc4MjIyMjk6Q3AxMjUyOjE1MjQ1MTU4MzE3MDE6VXNlcjotMTotMTowOjA6ZmFsc2U6Ti9BOlIxN19BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2018 02:37:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : User
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.SCT.CAPTURE
*-----------------------------------------------------------------------------
*<doc>
* TODO add a description of the application here.
* @author youremail@temenos.com
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 19/10/07 - EN_10003543
*            New Template changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'BD.SCT.CAPTURE'        ;* Full application name including product prefix
    Table.title = 'BD.SCT.CAPTURE'       ;* Screen title
    Table.stereotype = 'H'    ;* H, U, L, W or T
    Table.product = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct = ''     ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'FIN'        ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles = ''   ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix = 'SCT'        ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''       ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = ''         ;* Space delimeted list of blocked functions
    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
