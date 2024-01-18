SUBROUTINE TF.JBL.E.BLD.EXP.LCTYPE(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.LC.BD.BTBRECORD
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 05/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    ENQ.DATA<2,1> = '@ID'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1> = 'EACL EAUL EDUF EDCF EFDT EFDU EFST ESTF ESTC ESCF ESCL EFSC EMC EMTC EMTU EMU'
RETURN
*** </region>
END
