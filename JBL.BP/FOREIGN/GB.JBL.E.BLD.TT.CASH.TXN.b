SUBROUTINE GB.JBL.E.BLD.TT.CASH.TXN(ENQ.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History : ! Retrofit NILOY SARKAR
    ! NITSL 09/14/2022
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    ENQ.DATA<2,1> = 'VERSION.NAME'
    ENQ.DATA<3,1> = 'NE'
    ENQ.DATA<4,1> = 'SDSA.BK.CASHIN'

    ENQ.DATA<2,2> = 'VERSION.NAME'
    ENQ.DATA<3,2> = 'NE'
    ENQ.DATA<4,2> = 'SDSA.BK.CASHWDL'
END
 
