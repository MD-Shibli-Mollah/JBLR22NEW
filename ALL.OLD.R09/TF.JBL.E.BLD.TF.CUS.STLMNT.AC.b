SUBROUTINE TF.JBL.E.BLD.TF.CUS.STLMNT.AC(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.TF.CUST.STLMNT.ACCT
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 08/09/2020 -                            Create   - SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>='CATEGORY'
    ENQ.DATA<3,Y.POS>='EQ'
    ENQ.DATA<4,Y.POS>='1001 1002 1003 1004 1005 1979 6001 6002 6003 6004 6005 6006 6010 6011 6100 6101 6102'
RETURN
*** </region>

END
