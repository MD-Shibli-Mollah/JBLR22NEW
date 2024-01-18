SUBROUTINE TF.JBL.BLD.E.EXPPAYMENT.RTN(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection
*Subroutine Type:
*Attached To    : JBL.ENQ.EXPPAYMENT.NAU
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 05/11/2020 -                              CREATE   - MD. EBRAHIM KHALIL RIAN,
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
    ENQ.DATA<2,1> = 'LT.TF.VER.NAME'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1> = 'JBL.F.EXPDOCREAL JBL.I.EXPDOCREAL JBL.F.CONDOCREAL JBL.I.CONDOCREAL JBL.EXMXPYMT'
RETURN
*** </region>
END